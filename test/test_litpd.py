"""Integration tests for the generated litpd command-line program."""

from __future__ import annotations

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from shutil import copy2


ROOT = Path(__file__).resolve().parents[1]
LITPD = ROOT / "build" / "litpd.py"
DATA = ROOT / "test" / "data"


class LitpdIntegrationTests(unittest.TestCase):
    def run_litpd(self, fixture: str, output_name: str = "program.html") -> Path:
        temp_dir = tempfile.TemporaryDirectory()
        self.addCleanup(temp_dir.cleanup)
        work_dir = Path(temp_dir.name)
        (work_dir / "out").mkdir()

        completed = subprocess.run(
            [
                sys.executable,
                str(LITPD),
                str(DATA / fixture),
                "--to=html",
                "--output",
                output_name,
            ],
            cwd=work_dir,
            text=True,
            capture_output=True,
        )
        self.assertEqual(
            completed.returncode,
            0,
            msg=f"stdout:\n{completed.stdout}\nstderr:\n{completed.stderr}",
        )
        self.assertTrue((work_dir / output_name).is_file())
        return work_dir

    def test_document_without_code_file(self) -> None:
        self.run_litpd("test0-onlycode.md")

    def test_code_file_is_generated(self) -> None:
        work_dir = self.run_litpd("test1-codewfname.md")
        self.assertTrue((work_dir / "out" / "helloworld.lua").is_file())

    def test_code_ids_are_extracted(self) -> None:
        work_dir = self.run_litpd("test2-codeids.md")
        self.assertTrue((work_dir / "fnsay.tmp").is_file())
        self.assertTrue((work_dir / "sayhello.tmp").is_file())

    def test_code_id_references_are_tangled(self) -> None:
        work_dir = self.run_litpd("test4-codeid-use.md")
        generated_code = (work_dir / "hello3.lua").read_text(encoding="utf-8")
        self.assertIn("function say", generated_code)
        self.assertIn("function do", generated_code)
        self.assertIn('say("hello")', generated_code)

    def test_help(self) -> None:
        completed = subprocess.run(
            [sys.executable, str(LITPD), "--help"],
            text=True,
            capture_output=True,
        )
        self.assertEqual(completed.returncode, 0)
        self.assertIn("Usage:", completed.stdout)

    def test_version(self) -> None:
        completed = subprocess.run(
            [sys.executable, str(LITPD), "--version"],
            text=True,
            capture_output=True,
        )
        self.assertEqual(completed.returncode, 0)
        self.assertEqual(completed.stdout.strip(), "litpd 0.3.0-beta.0")

    def test_paths_with_spaces(self) -> None:
        with tempfile.TemporaryDirectory(prefix="litpd test ") as temp_dir:
            work_dir = Path(temp_dir)
            input_file = work_dir / "input document.md"
            output_file = work_dir / "program output.html"
            copy2(DATA / "test0-onlycode.md", input_file)

            completed = subprocess.run(
                [
                    sys.executable,
                    str(LITPD),
                    str(input_file),
                    "--to=html",
                    "--output",
                    str(output_file),
                ],
                cwd=work_dir,
                text=True,
                capture_output=True,
            )

            self.assertEqual(completed.returncode, 0, msg=completed.stderr)
            self.assertTrue(output_file.is_file())


if __name__ == "__main__":
    unittest.main()
