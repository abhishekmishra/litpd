#!/usr/bin/env python3
"""Command-line interface for litpd."""

from __future__ import annotations

import shlex
import shutil
import subprocess
import sys
from pathlib import Path
from typing import List, Optional

VERSION = "0.3.1b0"
USAGE = "Usage: litpd <inputfile.md> [pandoc options]"


def main(args: Optional[List[str]] = None) -> int:
    if args is None:
        args = sys.argv[1:]

    if args and args[0] in {"-V", "--version"}:
        print(f"litpd {VERSION}")
        return 0

    if not args or args[0] in {"-h", "--help"}:
        print(USAGE)
        return 0 if args else 2

    input_file = Path(args[0])
    if not input_file.is_file():
        print(f"Error: input file not found: {input_file}", file=sys.stderr)
        return 2

    pandoc = shutil.which("pandoc")
    if pandoc is None:
        print(
            "Error: Pandoc was not found. Install Pandoc and ensure it is in PATH.",
            file=sys.stderr,
        )
        return 127

    options = args[1:] or ["--output=program.html"]

    litpd_home = Path(__file__).resolve().parent
    tangle_filter = litpd_home / "litpd_filter.lua"

    if not tangle_filter.is_file():
        print(f"Error: required filter not found: {tangle_filter}", file=sys.stderr)
        return 2

    command = [
        pandoc,
        f"--lua-filter={tangle_filter}",
        "--from=markdown",
        str(input_file),
        *options,
    ]

    print("Executing:", shlex.join(command))

    try:
        completed = subprocess.run(command, check=False)
    except OSError as error:
        print(f"Error: could not start Pandoc: {error}", file=sys.stderr)
        return 1

    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
