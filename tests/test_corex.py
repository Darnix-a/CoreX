import contextlib
import importlib.machinery
import importlib.util
import io
import os
import pty
import shutil
import subprocess
import sys
import tempfile
import tomllib
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import corex_macos

loader = importlib.machinery.SourceFileLoader("corex_cli", str(ROOT / "corex"))
module_spec = importlib.util.spec_from_loader(loader.name, loader)
cx = importlib.util.module_from_spec(module_spec)
sys.modules[loader.name] = cx
loader.exec_module(cx)

with (ROOT / "config.default.toml").open("rb") as handle:
    STOCK = tomllib.load(handle)["commands"]
with (ROOT / "config.macos.toml").open("rb") as handle:
    MACOS = tomllib.load(handle)["commands"]


class CatalogTests(unittest.TestCase):
    def setUp(self):
        self.macos_module = mock.patch.object(cx, "corex_macos", corex_macos, create=True)
        self.macos_module.start()
        self.addCleanup(self.macos_module.stop)

    def load(self, macos, path=None):
        with mock.patch.object(cx, "IS_MACOS", macos):
            return cx.load_config(path or ROOT / "config.default.toml")

    def test_linux_catalog_matches_stock(self):
        cfg = self.load(False)
        self.assertEqual(set(STOCK), set(cfg.commands))
        for action, definition in STOCK.items():
            self.assertEqual(cfg.commands[action].command, definition["command"])
            self.assertEqual(cfg.commands[action].preview_cmd, definition.get("preview_cmd", ""))
            self.assertFalse(cfg.commands[action].unavailable)

    def test_mac_catalog_passes_doctor(self):
        self.assertTrue(set(MACOS) <= set(STOCK))
        cfg = self.load(True)
        self.assertEqual(set(STOCK), set(cfg.commands))
        console = io.StringIO()
        with mock.patch.object(cx, "IS_MACOS", True), contextlib.redirect_stdout(console):
            self.assertFalse(cx.builtin_doctor(cfg, dry_run=True))
        self.assertIn("100% Clean & Valid", console.getvalue())
        self.assertIn("Unavailable on macOS", console.getvalue())
        for spec in cfg.commands.values():
            if not spec.unavailable:
                with self.subTest(action=spec.id):
                    for command in (spec.command, spec.preview_cmd):
                        self.assertNotRegex(command, r"/proc/|/sys/|systemctl|nmcli|nvidia-smi|journalctl|wl-copy")

    def test_old_copied_catalog_uses_mac_variants_without_editing_user_file(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "config.toml"
            shutil.copyfile(ROOT / "config.default.toml", path)
            original = path.read_bytes()
            cfg = self.load(True, path)
            self.assertEqual(cfg.commands["snap-now"].command, "tmutil localsnapshot")
            self.assertEqual(cfg.commands["fkill"].preview_cmd, MACOS["fkill"]["preview_cmd"])
            self.assertEqual(path.read_bytes(), original)

    def test_local_platform_variant_can_replace_unavailable_action(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "config.toml"
            path.write_text(
                '[commands.cuda-purge.macos]\ncommand = "echo mac"\n'
                '[commands.hash-check]\ndescription = "My description"\n'
                '[commands.custom]\ncommand = "echo generic"\n'
                '[commands.custom.macos]\ncommand = "echo Mac"\n'
            )
            mac = self.load(True, path)
            linux = self.load(False, path)
            self.assertFalse(mac.commands["cuda-purge"].unavailable)
            self.assertEqual(mac.commands["cuda-purge"].command, "echo mac")
            self.assertEqual(mac.commands["hash-check"].description, "My description")
            self.assertEqual(mac.commands["hash-check"].deps, ["shasum", "md5"])
            self.assertEqual(mac.commands["custom"].command, "echo Mac")
            self.assertEqual(linux.commands["custom"].command, "echo generic")

    def test_unavailable_actions_never_execute_linux_command(self):
        cfg = self.load(True)
        with mock.patch.object(cx.subprocess, "run") as process, contextlib.redirect_stdout(io.StringIO()):
            with self.assertRaises(SystemExit) as error:
                cx.execute_command("cuda-purge", cfg)
            self.assertEqual(error.exception.code, 1)
            cx.execute_command("cuda-purge", cfg, dry_run=True)
            process.assert_not_called()

    def test_builtin_arguments_and_background_dispatch(self):
        cfg = self.load(True)
        with (
            mock.patch.object(cx, "IS_MACOS", True),
            mock.patch.object(cx.shutil, "which", return_value="/usr/local/bin/tool"),
            mock.patch.object(cx, "record_action_usage"),
            mock.patch.object(cx, "dispatch_builtin", return_value=None) as run,
            mock.patch.object(cx, "detach_background") as detach,
        ):
            cx.execute_command("rip-flac", cfg)
            run.assert_called_once_with("rip-audio", cfg, dry_run=False, extra_args=["flac"])
            cx.execute_command("mon-res", cfg, dry_run=True, bg_run=True, extra_args=["60"])
            self.assertIn("__builtin mac-display 60", detach.call_args.args[1])

    def test_warnings_do_not_mutate_system_in_dry_run(self):
        cfg = self.load(True)
        with mock.patch.object(cx, "IS_MACOS", True), mock.patch.object(cx.subprocess, "run") as run:
            with contextlib.redirect_stdout(io.StringIO()):
                cx.execute_command("snap-clean", cfg, dry_run=True)
                cx.execute_command("mon-dual", cfg, dry_run=True)
            run.assert_not_called()


class MacProbeTests(unittest.TestCase):
    def test_apple_silicon_page_size(self):
        stats = (
            "Mach Virtual Memory Statistics: (page size of 16384 bytes)\n"
            "Pages free: 65536.\nPages inactive: 32768.\nPages speculative: 16384.\n"
        )
        with mock.patch.object(corex_macos, "output", side_effect=["17179869184", stats]):
            self.assertEqual(corex_macos.memory_mib(), (16384, 1792))

    def test_discover_wifi_interface_without_assuming_en0(self):
        ports = "Hardware Port: Ethernet\nDevice: en0\n\nHardware Port: Wi-Fi\nDevice: en7\n"
        with mock.patch.object(corex_macos, "output", return_value=ports):
            self.assertEqual(corex_macos.wifi_device(), "en7")

    def test_native_launcher_shell_quoting_and_plist(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            executable = home / "it's a CoreX checkout" / "corex"
            with mock.patch.dict(os.environ, HOME=directory):
                launcher = corex_macos.install_launcher(executable, sys.executable, "/opt/homebrew/bin:/usr/bin")
                shell = launcher / "Contents/MacOS/corex-launcher"
                subprocess.run(["sh", "-n", str(shell)], check=True)
                self.assertTrue(os.access(shell, os.X_OK))
                self.assertTrue((launcher / "Contents/Info.plist").is_file())


class CLITests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory(prefix="corex test ")
        self.addCleanup(directory.cleanup)
        self.home = Path(directory.name)
        self.env = {**os.environ, "HOME": directory.name, "TERM": "xterm-256color"}

    def run_cli(self, *args, check=True):
        return subprocess.run(
            [str(ROOT / "cx"), *args], env=self.env, cwd=ROOT, text=True,
            capture_output=True, check=check, timeout=30,
        )

    def test_cli_uses_native_catalog(self):
        result = self.run_cli("--list")
        self.assertEqual(len(result.stdout.splitlines()), len(STOCK))
        self.assertEqual("unavailable on macOS" in result.stdout, sys.platform == "darwin")
        self.assertIn("100% Clean & Valid", self.run_cli("doctor", "--dry-run").stdout)
        self.assertIn("flac", self.run_cli("rip-flac", "--dry-run").stdout)
        self.assertIn("PROCESS FORENSICS", self.run_cli("proc", str(os.getpid())).stdout)

    def test_launcher_with_fzf(self):
        master, slave = pty.openpty()
        try:
            result = subprocess.run(
                [str(ROOT / "cx"), "--dry-run"], stdin=slave, text=True, check=True,
                capture_output=True, timeout=10, env={**self.env, "FZF_DEFAULT_OPTS": "--filter=calc"},
            )
        finally:
            os.close(slave)
            os.close(master)
        self.assertIn("Built-in action: cx __builtin calc", result.stdout)

    def test_process_arguments_keep_their_order(self):
        parsed, unknown = cx.parse_cli_args(["proc", "100", "--nice", "-1"])
        self.assertEqual(parsed.args, ["100", "--nice", "-1"])
        self.assertEqual(unknown, [])

    def test_pins_and_profile_round_trip(self):
        self.run_cli("pin", "disks")
        self.assertIn("disks", self.run_cli("pinned").stdout)
        profile = self.home / "profile.json"
        self.run_cli("export", str(profile))
        self.run_cli("unpin", "disks")
        self.run_cli("import", str(profile))
        self.assertIn("disks", self.run_cli("pinned").stdout)

    def test_install_and_uninstall(self):
        config = self.home / ".config/corex/config.toml"
        config.parent.mkdir(parents=True)
        config.write_text('[general]\neditor = "vi"\n')
        subprocess.run(["bash", "install.sh"], cwd=ROOT, env=self.env, check=True, capture_output=True, timeout=30)
        self.assertEqual(config.read_text(), '[general]\neditor = "vi"\n')
        bin_path = self.home / ".local/bin/cx"
        self.assertEqual(bin_path.resolve(), ROOT / "corex")
        launcher = ("Applications/CoreX.app/Contents/Info.plist" if sys.platform == "darwin"
                    else ".local/share/applications/corex.desktop")
        self.assertTrue((self.home / launcher).exists())
        subprocess.run(["bash", "uninstall.sh", "--keep-folder", "-y"], cwd=ROOT, env=self.env,
                       check=True, capture_output=True, timeout=30)
        self.assertFalse(bin_path.exists())
        self.assertFalse((self.home / launcher).exists())
        self.assertTrue((ROOT / "corex").exists())

    @unittest.skipUnless(sys.platform == "darwin", "requires macOS and its SDK")
    def test_mac_native_helper_builds_and_runs(self):
        binary = corex_macos.native_helper(self.home / ".cache/corex", ROOT)
        result = subprocess.check_output([str(binary), "--self-test"], text=True)
        self.assertIn("CoreX native helper", result)
        subprocess.run(["codesign", "--verify", str(binary.parents[2])], check=True)
        self.assertIn("macOS", self.run_cli("sys-info").stdout)
        self.assertIn("STORAGE & PARTITION TELEMETRY", self.run_cli("disks").stdout)
        self.assertEqual(self.run_cli("cuda-purge", check=False).returncode, 1)

    @unittest.skipUnless(sys.platform == "darwin", "requires macOS command-line tools")
    def test_mac_hashes_and_resource_accounting(self):
        sample = self.home / "sample file"
        sample.write_text("CoreX\n")
        result = subprocess.run(
            [str(ROOT / "cx"), "hash-check"], env=self.env,
            input=f"{sample}\n", text=True, capture_output=True, check=True, timeout=10,
        )
        self.assertRegex(result.stdout, r"[a-f0-9]{64}")
        self.assertRegex(result.stdout, r"[a-f0-9]{32}\n")
        result = self.run_cli("perf-stat", "/usr/bin/true")
        self.assertIn("maximum resident set size", result.stderr)


if __name__ == "__main__":
    unittest.main()
