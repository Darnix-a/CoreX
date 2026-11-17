"""macOS command probes and native helper installation."""

import os
import plistlib
import re
import shutil
import subprocess
import tempfile
import time
from pathlib import Path


def output(*args, timeout=4):
    try:
        return subprocess.run(
            args, capture_output=True, text=True, check=True, timeout=timeout
        ).stdout.strip()
    except (OSError, subprocess.SubprocessError):
        return ""


def uptime_seconds():
    boot = re.search(r"sec\s*=\s*(\d+)", output("sysctl", "-n", "kern.boottime"))
    return max(0, int(time.time()) - int(boot[1])) if boot else None


def memory_mib():
    total = output("sysctl", "-n", "hw.memsize")
    if not total.isdecimal():
        return 0, None
    total_mib = int(total) // 1024**2
    stats = output("vm_stat")
    page_size = re.search(r"page size of (\d+) bytes", stats)
    if not page_size:
        return total_mib, None
    pages = dict(re.findall(r"^([^:\n]+):\s+(\d+)\.", stats, re.M))
    available = sum(int(pages.get(key, 0)) for key in ("Pages free", "Pages inactive", "Pages speculative"))
    return total_mib, min(total_mib, available * int(page_size[1]) // 1024**2)


def wifi_device():
    ports = output("networksetup", "-listallhardwareports")
    device = re.search(r"^Hardware Port: (?:Wi-Fi|AirPort)\s*\nDevice:\s+(\S+)", ports, re.M)
    return device[1] if device else ""


def native_helper(cache, source_dir):
    """Build on first use with Xcode Command Line Tools and cache the native binary."""
    import hashlib

    source = source_dir / "packaging" / "macos" / "workstation.swift"
    info = source.with_name("Info.plist")
    signature = hashlib.sha256(source.read_bytes() + info.read_bytes()).hexdigest()[:16]
    cache.mkdir(parents=True, exist_ok=True)
    bundle = cache / f"Workstation-{signature}.app"
    executable = bundle / "Contents/MacOS/workstation"
    if executable.is_file():
        return executable
    if not output("xcrun", "--find", "swiftc"):
        raise RuntimeError("Install the Xcode Command Line Tools with xcode-select --install.")

    with tempfile.TemporaryDirectory(dir=cache) as work:
        staging = Path(work) / bundle.name
        binary = staging / "Contents/MacOS/workstation"
        binary.parent.mkdir(parents=True)
        shutil.copyfile(info, staging / "Contents/Info.plist")
        subprocess.run(
            ["xcrun", "swiftc", "-O", str(source), "-o", str(binary)],
            check=True, timeout=120,
        )
        subprocess.run(["codesign", "--force", "--sign", "-", str(staging)], check=True, timeout=20)
        try:
            staging.rename(bundle)
        except OSError:
            if not executable.is_file():
                raise
    return executable


def install_launcher(executable, python, path):
    """Install a Finder/Spotlight launcher that opens CoreX in Terminal."""
    import shlex

    bundle = Path.home() / "Applications" / "CoreX.app"
    binary = bundle / "Contents/MacOS/corex-launcher"
    binary.parent.mkdir(parents=True, exist_ok=True)
    search_path = os.pathsep.join(dict.fromkeys([str(executable.parent), *path.split(os.pathsep)]))
    command = f"export PATH={shlex.quote(search_path)}; {shlex.join([python, str(executable)])}"
    binary.write_text(
        "#!/bin/sh\n"
        f"exec /usr/bin/osascript - {shlex.quote(command)} <<'APPLESCRIPT'\n"
        "on run argv\n"
        '    tell application "Terminal"\n'
        "        activate\n"
        "        do script (item 1 of argv)\n"
        "    end tell\n"
        "end run\n"
        "APPLESCRIPT\n",
        encoding="utf-8",
    )
    binary.chmod(0o755)
    with (bundle / "Contents" / "Info.plist").open("wb") as info:
        plistlib.dump({
            "CFBundleExecutable": binary.name,
            "CFBundleIdentifier": "io.github.darnix-a.corex",
            "CFBundleName": "CoreX",
            "CFBundlePackageType": "APPL",
            "NSAppleEventsUsageDescription": "CoreX opens its launcher in Terminal.",
            "LSUIElement": True,
        }, info)
    return bundle
