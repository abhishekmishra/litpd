---
title: "litpd: Literate Programming for Pandoc Markdown"
date: 21/03/2024
author: "[Abhishek Mishra](https://neolateral.in)"
---

**Revisions**

| Version      | Date       | Comments                                                                                                  |
| ------------ | ---------- | --------------------------------------------------------------------------------------------------------- |
| 0.1a-alpha.0 | 21/03/2024 | Initial version                                                                                           |
| 0.1a-alpha.1 | 10/04/2024 | Second alpha release, add code fragments with code_id support.                                            |
| 0.2.0-beta.0 | 18/05/2025 | First beta release, support for powershell and bash scripts and installation procedure documented.        |
| 0.3.0-beta.0 | 01/09/2026 | Replace the Lua, PowerShell, and Bash launchers with a cross-platform Python CLI.                         |
| 0.3.1b0 | 01/09/2026 | Replace temporary code-fragment files with an in-memory filter, organize the filter as code_id chunks, and publish a Python package. |

# Introduction

> 1. Write a program's code and design in markdown.
> 2. Use litpd to generate the readable and runnable avatars of your program.
> 3. Profit?!!

This document describes a simple [literate programming][1] tool. It is
developed for use in my own programming projects. I use markdown for most
documentation, and I use `lua` for most of my programming needs these days.
This tool uses [pandoc][3] to process a markdown file to one of the supported
printable/publishable outputs supported by pandoc. The tool also includes
a lua filter to process the code blocks in the literate program document to
generate output programs in their own files.

This tool is itself written as a literate program and can be found at
[github/litpd][7]

## What is Literate Programming?

For those unfamiliar to the term "literate programming", I would refer you to
the excellent writings on the topic by [Donald Knuth][2]. In short literate
programming is about program definition in a document which is written as a work
of literature. Therefore one of the primary objectives of a literate program is
to be read and enjoyed by another programmer. The literate program document can
also be used to create an executable program or a library in the target
programming language.

[1]: https://en.wikipedia.org/wiki/Literate_programming
[3]: https://pandoc.org/
[2]: https://www-cs-faculty.stanford.edu/~knuth/lp.html
[7]: https://github.com/abhishekmishra/litpd

# Getting Started

To quickly get started with using the litpd program, follow the instructions to
ensure you have the pre-requisites and then install and test the litpd release.

There are two pre-requisites:

1. Python 3.8 or newer (only for the source/archive distribution)
2. Pandoc (install the latest available for your platform)

The Lua filters are executed by Pandoc. A separate Lua installation is not
required.

## Installing Python

See the downloads page on the Python website for installation packages and
instructions -> [Python: Downloads](https://www.python.org/downloads/).

**Important: Ensure Python is added to the path after installation.**

## Installing Pandoc

See instructions for your platform at the pandoc website ->
[Installing Pandoc](https://pandoc.org/installing.html).

**Important: Ensure pandoc is added to the path after installation**

## Installing litpd

The recommended installation method is [pipx](https://pipx.pypa.io/), which
installs the command in an isolated Python environment:

```bash
pipx install litpd
```

You can then run `litpd` from any directory. Pandoc must still be installed and
available on your `PATH`.

### Installing with pip

`pipx` is recommended for command-line applications, but it is not required.
To install litpd into your active Python environment, run:

```bash
python3 -m pip install litpd
```

The `litpd` command must be on your `PATH` after installation. Pandoc must also
be installed and available on your `PATH`.

### Archive distribution

1. Create litpd directory and change to it.
2. Download the latest release zip.
3. Unzip the release zip.

### Windows

```powershell
New-Item -ItemType Directory -Force -Name "litpd"; Set-Location "litpd"; Invoke-WebRequest -Uri "https://github.com/abhishekmishra/litpd/releases/latest/download/litpd.zip" -OutFile "litpd.zip"; Expand-Archive -Path "litpd.zip" -DestinationPath "."
```

### Linux/MacOS/Unix-like

```bash
mkdir -p litpd && cd litpd && curl -L -o litpd.tar.gz "https://github.com/abhishekmishra/litpd/releases/latest/download/litpd.tar.gz" && tar -xzf litpd.tar.gz
```

## Running litpd

In this section we will run litpd with the sample "Hello World!" program in the
file `helloworld.md` to generate the html readable program, and the helloworld
runnable programs in various programming languages.

_Open `helloworld.md` program in your favourite text editor to see what it looks
like._

### Windows

On Windows, run the Python program with the Python launcher:

```powershell
# Change to the litpd directory
cd litpd

# Run litpd with helloworld.md
litpd helloworld.md
```

### Linux/MacOS/Unix-like

```bash
# Change to the litpd directory
cd litpd

# Run litpd with helloworld.md
litpd helloworld.md
```

### Result

You should now see the following files:

1. `program.html`: This is the readable/printable version of the program.
2. `helloworld.lua,helloworld.py,etc.`: The runnable programs generated from
   `helloworld.md`.

# The litpd Program

The litpd command-line program is written in Python. Its Pandoc filters are
written in the [Lua programming language][4], the language supported by
Pandoc's built-in scripting engine. The goal of the program is two-fold:

1. **Readable Program**: Generate a publishable/printable Program Description in
   HTML or PDF formats.
2. **Runnable Program**: Separate out and/or merge code blocks into individual
   program files so that they can be used as a normal program in the target
   language.

The program uses **pandoc** to perform the generation of the final readable
document with minor adjustments. Therefore this part of the program simply
delegates to pandoc.

To generate the source code in proper files and structure, we inject a lua
filter program into the pandoc processing flow. This program extracts the
code from the document and writes it to the target program file(s).

The approach is also described in the High-level design diagram below.

<img src="HLDDiagram.png" alt="High Level Design of litpd" width="100%" />

## Components of litpd

As you have seen in the design diagram above, the litpd process uses pandoc
to generate both the readable and runnable avatars of the program. The user of
litpd interacts directly with the cross-platform `litpd` command. This program
ensures Pandoc is available, then starts Pandoc with its bundled Lua filter to
get the runnable avatar of the program. Since the input program is already in Pandoc
markdown format, pandoc can be used trivially to get the readable avatar of the
literate program.

Therefore, the **litpd** application is composed of the following components:

1. **litpd**: This command is the main CLI tool used to generate the
   publishable document and the runnable program from the input literate
   program written in the [pandoc markdown format][5].
2. **litpd_filter.lua**: This [Pandoc Lua filter][6] runs during document
   generation and extracts the source code of the literate program into proper
   output program files, expanding reusable `code_id` fragments along the way.

[4]: https://lua.org/about.html
[5]: https://pandoc.org/MANUAL.html#pandocs-markdown
[6]: https://pandoc.org/lua-filters.html

## Package Initializer

The installed distribution is a Python package. Its initializer exposes the
same PEP 440 version used in the package metadata.

```python {code_file="src/litpd/__init__.py"}
"""Literate programming tools for Pandoc Markdown."""

__version__ = "0.3.1b0"
```

## CLI Program - litpd

The `litpd` command provides a command line interface to the literate
programming tool. It allows us to run the pandoc conversion of the literate
program document into the publishable document and the runnable program using
the `mdtangle.lua` filter as well as compile the output into proper files at
the proper locations.

The program has the following parts:

1. **Program documentation**
2. **Extract program arguments and check prerequisites**
3. **Construct the pandoc command**
4. **Run the pandoc command and check for errors**

We will discuss each part one by one.

### Program Header

The Python standard library provides everything required by the CLI. `Path` is
used for reliable cross-platform paths, `shutil` locates Pandoc, and
`subprocess` runs it without invoking a command shell.

```python {code_file="src/litpd/cli.py"}
#!/usr/bin/env python3
"""Command-line interface for litpd."""

from __future__ import annotations

import shlex
import shutil
import subprocess
import sys
from pathlib import Path
from typing import List, Optional
```

### Program Arguments

The first argument is the input literate-programming document. Any remaining
arguments are passed to Pandoc unchanged. If no Pandoc options are supplied,
litpd generates `program.html` by default.

```python {code_file="src/litpd/cli.py"}

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
```

### Construct and Display Pandoc Command

In the next section of the program we now construct the pandoc command to run
such that both the output document, and output code are generated correctly.

- The `tangle_filter` variable stores the path to the Lua Pandoc filter. It
  collects `code_id` fragments in memory, expands them, and writes code blocks
  marked with `code_file` to their target files.
- The command is constructed as a list of arguments. This preserves spaces and
  other characters in filenames and prevents a shell from interpreting user
  input.

```python {code_file="src/litpd/cli.py"}

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
```

### Run the Pandoc Command

`subprocess.run` connects Pandoc directly to the terminal. A Pandoc failure is
returned to the caller as the CLI's exit status, making failures visible to
scripts, build systems, and continuous integration.

```python {code_file="src/litpd/cli.py"}

    try:
        completed = subprocess.run(command, check=False)
    except OSError as error:
        print(f"Error: could not start Pandoc: {error}", file=sys.stderr)
        return 1

    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
```

## Filter Program - litpd_filter.lua

The `litpd_filter.lua` program is a [pandoc lua filter][7]. A pandoc filter is
a program which is executed by Pandoc during its filtration phase. The filter
has access to the abstract syntax tree (AST) of the input document. This access
allows the filter program to implement transformations and functionality that
are not part of standard Pandoc processing.

The filter is interested in `CodeBlock` sections that have either a `code_id`
or a `code_file` attribute. The value of `code_id` identifies a reusable code
fragment. Once the author creates such a block, it can be referenced from
another code block with `@<CODE_ID@>`. This lets the document introduce parts
of a program according to the flow of its ideas, independently of how source
code is finally arranged in files.

The same filter first collects every `code_id` fragment from the AST into an
in-memory table, then expands those references while writing `code_file`
blocks. It replaces the earlier two-filter, temporary-file handoff: no fragment
files are created in the working directory.

The filter is itself organized as logical fragments. The final block at the end
of this section assembles those fragments into `litpd_filter.lua`.

### Program Header and State

```lua {code_id="filter_header"}
--- litpd_filter.lua - Pandoc filter for tangling literate-program source files.
-- license: MIT see LICENSE file
-- author: Abhishek Mishra

local fragments = {}
local written_files = {}

```

### Collect Fragments

The first pass visits every code block, including blocks nested in other
structures, and records its text by `code_id`. This is the in-memory equivalent
of the old extraction step, but its data exists only for the duration of the
Pandoc run.

```lua {code_id="filter_collect"}
local function collect_fragments(doc)
    doc:walk({
        CodeBlock = function(code_block)
            local code_id = code_block.attributes["code_id"]
            if code_id then
                fragments[code_id] = code_block.text
            end
        end,
    })
end

```

### Expand References

References are expanded recursively from the in-memory table. Unknown and
circular references fail clearly instead of silently producing incomplete code.

```lua {code_id="filter_expand"}
local function expand(code, stack)
    stack = stack or {}
    return (code:gsub("@<([A-Za-z0-9_]+)@>", function(code_id)
        local fragment = fragments[code_id]
        if not fragment then
            error("Unknown code_id: " .. code_id)
        end
        if stack[code_id] then
            error("Circular code_id reference: " .. code_id)
        end
        stack[code_id] = true
        local expanded = expand(fragment, stack)
        stack[code_id] = nil
        return expanded
    end))
end

```

### Write and Label Code Blocks

Each code block generated into its own file specifies that output filename in
the fenced block's `code_file` attribute. The first block for a target opens it
in write mode; later blocks append. Therefore a fresh generation replaces old
output rather than appending to it from a previous run. Code blocks continue to
receive `id:` and `file:` labels in the readable document.

```lua {code_id="filter_write"}
local function write_code_block(code_block)
    local full_path = code_block.attributes["code_file"]
    if not full_path then
        return nil
    end

    local mode = written_files[full_path] and "a" or "w"
    local file, error_message = io.open(full_path, mode)
    if not file then
        error("Could not open " .. full_path .. ": " .. error_message)
    end
    file:write(expand(code_block.text))
    file:write("\n")
    file:close()
    written_files[full_path] = true
    return full_path
end

local function label_code_block(code_block)
    local labels = {}
    local code_id = code_block.attributes["code_id"]
    if code_id then
        table.insert(labels, pandoc.Strong(pandoc.Str("id: " .. code_id)))
    end

    local full_path = write_code_block(code_block)
    if full_path then
        table.insert(labels, pandoc.Strong(pandoc.Str("file: " .. full_path)))
    end

    if #labels == 0 then
        return nil
    end
    table.insert(labels, code_block)
    return labels
end

```

### Pandoc Entry Point

```lua {code_id="filter_entry"}
function Pandoc(doc)
    collect_fragments(doc)
    return doc:walk({CodeBlock = label_code_block})
end
```

### Assemble the Filter

```lua {code_file="src/litpd/litpd_filter.lua"}
@<filter_header@>
@<filter_collect@>
@<filter_expand@>
@<filter_write@>
@<filter_entry@>
```

# License

This project, including its documentation, is licensed under the
[MIT License](LICENSE).

# Future Plans

Potential improvements include:

- **Ignore Code Blocks**: Allow example or aside code blocks to appear in the
  documentation without being written to generated program files.
