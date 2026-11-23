import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


COREX = Path(__file__).resolve().parents[1] / "corex"
WRAPPER = """
import runpy, subprocess, sys
from pathlib import Path
corex, work, *args = sys.argv[1:]
main = runpy.run_path(corex)["main"]
module = main.__globals__
module["STATE_FILE"] = Path(work) / "stats.json"
module["detach_background"] = lambda name, command: subprocess.run(
    ["sh", "-c", command], check=True
)
sys.argv = [corex, "--config", str(Path(work) / "corex.toml"), *args]
main()
"""


@unittest.skipUnless(os.environ.get("CX_KIRO_LIBRARY"), "set CX_KIRO_LIBRARY to the built Kiro library")
class KiroActions(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix="corex-kiro-")
        self.addCleanup(temp.cleanup)
        self.work = Path(temp.name)
        self.script = self.work / "test script.kr"
        self.script.write_text(
            'import cx\nreturn {action: cx.command, args: args, found: cx.has_command("kiro-test")}\n'
        )
        (self.work / "corex.toml").write_text(
            "[general]\ncolor = false\n[commands.kiro-test]\n"
            f"command = {json.dumps('cx kiro ' + repr(str(self.script)))}\n"
        )

    def run_cx(self, *args):
        return subprocess.run([sys.executable, "-c", WRAPPER, str(COREX), str(self.work), *args],
                              cwd=self.work, capture_output=True, text=True, timeout=10)

    def assert_action(self, result, action, args):
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout), {"action": action, "args": args, "found": True})

    def test_foreground_keeps_literal_arguments_and_uses_host_module(self):
        args = ["--dry-run", "a 'quote'; echo unintended", ""]
        self.assert_action(self.run_cx("kiro", str(self.script), *args), "test script", args)

    def test_configured_macro_and_background_share_the_embedder(self):
        args = ["a 'quote'; echo unintended", "--flag"]
        self.assert_action(self.run_cx("kiro-test", "--", *args), "kiro-test", args)
        self.assert_action(self.run_cx("--bg", "kiro-test", "--", *args), "kiro-test", args)
        self.assert_action(self.run_cx("bg", "run", str(self.script), *args), "test script", args)

    def test_exit_status_propagates_without_printing_a_result(self):
        self.script.write_text("exit(19)\n")
        result = self.run_cx("kiro", str(self.script))
        self.assertEqual(result.returncode, 19, result.stderr)
        self.assertEqual(result.stdout, "")


if __name__ == "__main__":
    unittest.main()
