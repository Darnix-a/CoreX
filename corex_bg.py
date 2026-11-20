"""CoreX background jobs on systemd and on systems without a systemd user session."""

import contextlib
import fcntl
import json
import os
import re
import select
import shutil
import signal
import subprocess
import sys
import time
from pathlib import Path


def unit_name(target, *, action=False):
    name = target if action else target.removesuffix(".service").removeprefix("corex-")
    if not re.fullmatch(r"[A-Za-z0-9_-]{1,180}", name):
        raise ValueError("Expected an action name or a corex-<name>.service unit.")
    return f"corex-{name}.service"


SYSTEMCTL = ["systemctl", "--user"]
PROPERTIES = "Id,LoadState,ActiveState,SubState,MainPID,MemoryCurrent,CPUUsageNSec,ActiveEnterTimestamp"


def systemd_available():
    return (
        sys.platform != "darwin"
        and shutil.which("systemd-run")
        and shutil.which("systemctl")
        and subprocess.run([*SYSTEMCTL, "show-environment"], capture_output=True, timeout=5).returncode == 0
    )


def systemd_info(unit):
    result = subprocess.run(
        [*SYSTEMCTL, "show", f"--property={PROPERTIES}", "--", unit],
        capture_output=True, text=True, timeout=8,
    )
    fields = dict(row.split("=", 1) for row in result.stdout.splitlines() if "=" in row)
    if fields.get("LoadState") in (None, "not-found"):
        return None
    memory = fields.get("MemoryCurrent", "")
    cpu = fields.get("CPUUsageNSec", "")
    return {
        "unit": unit, "state": fields.get("ActiveState", "unknown"),
        "pid": fields.get("MainPID", "0"), "since": fields.get("ActiveEnterTimestamp", ""),
        "memory": int(memory) if memory.isdigit() and int(memory) < 2**64 - 1 else None,
        "cpu": int(cpu) / 1e9 if cpu.isdigit() and int(cpu) < 2**64 - 1 else None,
    }


def systemd_names():
    output = subprocess.check_output(
        [*SYSTEMCTL, "list-units", "--all", "--type=service", "--plain",
         "--no-legend", "--full", "corex-*.service"],
        text=True, timeout=8,
    )
    return [row.split()[0] for row in output.splitlines() if row.strip()]


def systemd_command(unit, shell, command):
    return [
        "systemd-run", "--user", f"--unit={unit}", "--collect",
        "--property=Type=exec", "--property=CollectMode=inactive-or-failed",
        f"--working-directory={os.getcwd()}", "--setenv=PATH", "--setenv=HOME",
        "--", shell, "-c", command.replace("$", "$$"),
    ]


class LocalJobs:
    """Detached jobs controlled through private FIFOs and tracked by process-held locks."""

    def __init__(self, state_dir):
        self.root = state_dir / "jobs"
        self.logs = state_dir / "logs"

    @contextlib.contextmanager
    def transaction(self, *, blocking=True):
        self.root.mkdir(parents=True, exist_ok=True, mode=0o700)
        with (self.root / "manager.lock").open("a") as handle:
            mode = fcntl.LOCK_EX if blocking else fcntl.LOCK_EX | fcntl.LOCK_NB
            fcntl.flock(handle, mode)
            yield

    def log_path(self, unit):
        return self.logs / f"{unit.removesuffix('.service')}.log"

    def info(self, unit):
        state = self.root / unit
        try:
            with state.with_suffix(".lock").open("r") as handle:
                try:
                    fcntl.flock(handle, fcntl.LOCK_EX | fcntl.LOCK_NB)
                except BlockingIOError:
                    return json.loads(state.read_text())
                for path in (state, state.with_suffix(".fifo"), state.with_suffix(".tmp"), state.with_suffix(".lock")):
                    path.unlink(missing_ok=True)
        except FileNotFoundError:
            return None
        return None

    def names(self):
        with self.transaction():
            return sorted(path.with_suffix(".service").name for path in self.root.glob("corex-*.lock")
                          if self.info(path.with_suffix(".service").name))

    def status(self, unit):
        with self.transaction():
            job = self.info(unit)
        if not job:
            return None
        result = subprocess.run(["ps", "-p", str(job["pid"]), "-o", "rss=", "-o", "time="],
                                capture_output=True, text=True, timeout=5)
        fields = result.stdout.split(None, 1)
        if len(fields) == 2 and fields[0].isdigit():
            job["memory"] = int(fields[0]) * 1024
            job["cpu_display"] = fields[1].strip()
        return job

    def start(self, unit, shell, command):
        with self.transaction():
            active = self.info(unit)
            if active:
                return active
            path = self.root / unit
            pipe = path.with_suffix(".fifo")
            self.logs.mkdir(parents=True, exist_ok=True, mode=0o700)
            os.mkfifo(pipe, mode=0o600)
            worker = None
            try:
                with path.with_suffix(".lock").open("x") as lock, self.log_path(unit).open("a") as log:
                    fcntl.flock(lock, fcntl.LOCK_EX)
                    worker = subprocess.Popen(
                        [sys.executable, str(Path(__file__).resolve()), str(path), str(lock.fileno()),
                         shell, command],
                        stdin=subprocess.DEVNULL, stdout=log, stderr=subprocess.STDOUT,
                        start_new_session=True, pass_fds=(lock.fileno(),),
                    )
                    deadline = time.monotonic() + 5
                    while not path.exists() and worker.poll() is None and time.monotonic() < deadline:
                        time.sleep(0.02)
                    if not path.exists():
                        raise RuntimeError(f"Background job failed to start. See {self.log_path(unit)}")
            except BaseException:
                if worker is not None and worker.poll() is None:
                    worker.terminate()
                    try:
                        worker.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        worker.kill()
                        worker.wait()
                self.info(unit)
                pipe.unlink(missing_ok=True)
                raise
            return None

    def control(self, unit, action):
        with self.transaction():
            current = self.info(unit)
            if not current:
                return False
            pipe = (self.root / unit).with_suffix(".fifo")
            try:
                fd = os.open(pipe, os.O_WRONLY | os.O_NONBLOCK)
                with os.fdopen(fd, "wb") as handle:
                    handle.write(action.encode() + b"\n")
            except (FileNotFoundError, BrokenPipeError):
                return False
            deadline = time.monotonic() + 8
            while time.monotonic() < deadline:
                job = self.info(unit)
                if not job:
                    return action == "stop"
                if action == "restart" and job["pid"] != current["pid"]:
                    return True
                time.sleep(0.05)
            raise RuntimeError(f"Timed out waiting for {unit} to {action}.")


def terminate_group(child):
    with contextlib.suppress(ProcessLookupError):
        os.killpg(child.pid, signal.SIGTERM)
    try:
        child.wait(timeout=3)
    except subprocess.TimeoutExpired:
        with contextlib.suppress(ProcessLookupError):
            os.killpg(child.pid, signal.SIGKILL)
        child.wait()


def run_worker(path, fd, shell, command):
    # The inherited descriptor keeps the job active through command restarts.
    os.set_inheritable(fd, False)
    pipe = path.with_suffix(".fifo")
    child = None
    read_fd = os.open(pipe, os.O_RDONLY | os.O_NONBLOCK)
    write_fd = os.open(pipe, os.O_WRONLY | os.O_NONBLOCK)
    pending = path.with_suffix(".tmp")

    def stop_worker(_signal, _frame):
        raise SystemExit(0)

    signal.signal(signal.SIGTERM, stop_worker)

    def start_child():
        process = subprocess.Popen([shell, "-c", command], start_new_session=True)
        status = {
            "unit": path.name, "state": "active", "pid": process.pid,
            "since": time.strftime("%Y-%m-%d %H:%M:%S %Z"),
        }
        pending.write_text(json.dumps(status))
        pending.replace(path)
        return process

    try:
        child = start_child()
        while child.poll() is None:
            if not select.select([read_fd], [], [], 0.2)[0]:
                continue
            requests = os.read(read_fd, 1024).splitlines()
            if b"stop" in requests:
                return
            if b"restart" in requests:
                terminate_group(child)
                child = start_child()
    finally:
        if child is not None:
            terminate_group(child)
        pending.unlink(missing_ok=True)
        os.close(write_fd)
        os.close(read_fd)
        os.close(fd)
        jobs = LocalJobs(path.parent.parent)
        with contextlib.suppress(BlockingIOError):
            with jobs.transaction(blocking=False):
                jobs.info(path.name)


if __name__ == "__main__":
    run_worker(Path(sys.argv[1]), int(sys.argv[2]), *sys.argv[3:])
