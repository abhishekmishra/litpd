---
title:  "litpd: Literate Programming for Pandoc Markdown"
date:   21/03/2024
author: Abhishek Mishra
---

# Introduction

This document describes a simple [literate programming][1] tool. It is
developed for use in my own programming projects. I use markdown for most
documentation, and I use `lua` for most of my programming needs these days.
This tool uses [pandoc][3] to process a markdown file to one of the supported
printable/publishable outputs supported by pandoc. The tool also includes
a lua filter to process the code blocks in the literate program document to
generate output programs in their own files.

This tool is itself written as a literate program and can be found at
TODO: link

## What is Literate Programming?

For those unfamiliar to the term "literate programming", I would refer you to 
the excellent writings on the topic by [Donald Knuth][2]. In short literate
programming is about program definition in a document which is written as a
work of literature. Therefore one of the primary objectives of a literate
program is to be read and enjoyed by another programmer. The literate program
document can also be used to create an executable program or a library in the
target programming language.

[1]: https://en.wikipedia.org/wiki/Literate_programming
[3]: https://pandoc.org/
[2]: https://www-cs-faculty.stanford.edu/~knuth/lp.html

# The litpd Program

The litpd program is written in the [Lua programming language][4]. It is
composed of two programs.

1. **litpd.lua**: This program is the main cli tool used to generate the
   publishable document and the runnable program from the input literate
   program written in the [pandoc markdown format][5].
2. **mdtangle.lua**: This program is a [pandoc lua filter][6]. The goal of this
   program is to run during the filter phase of document generation and extract
   the source code of the literate program into proper output program files.

[4]: https://lua.org/about.html
[5]: https://pandoc.org/MANUAL.html#pandocs-markdown
[6]: https://pandoc.org/lua-filters.html

## CLI Program - litpd.lua

The `litpd.lua` program provides a command line interface to the literate
programming tool. It allows us to run the pandoc conversion of the literate
program document into the publishable document and the runnable program using
the `mdtangle.lua` filter as well as compile the output into proper files at
the proper locations.

The program has the following parts:

1. **Program documentation**
2. **Extract program arguments & check required arguments**
3. **Construct the pandoc command**
4. **Run the pandoc command and check for errors**

We will discuss each part one by one.

### Program Header

This part is self-explanatory and provides the header of the program
in standard lua documentation format.

```lua {code_file="litpd.lua"}
--- litpd.lua - Main CLI program for litpd tool.
--
-- license: MIT see LICENSE file
-- date: 21/03/2024
-- author: Abhishek Mishra
```

### Program Arguments

In this section of the program, we first construct the `args` table from the
program arguments.

* The `script_path` stores the first argument which is usually the name of
  the lua program being run, if this is run from a standard lua executable.
* In case the `script_path` contains any windows `\` backslash path separators,
  we replace them with `/` slashes.
* The we match anything before the last `\` of the `script_path` as the path
  of the directory containing the program, and store the result in `litmd_home`.
* Next we define a function `show_usage` which prints the usage of the command,
  this is used when the user does not pass the proper expected arguments to the
  command.
* Finally we look at the arguments:
  * If the length of the args is 0, then we print usage and exit.
  * If the first argument (i.e. the input literate programming document) is
    not provided, then we print the usage and exit. Else we store the input file
    name in `input_file`.
  * The rest of the arguments are assumed to be pandoc arguments and are stored
    in a separate table called `options`.

```lua {code_file="litpd.lua"}

-- get the arguments from the command line
local args = {...}

-- get the path of script, and its directory
local script_path = arg[0]
-- replace all backslashes with forward slashes
script_path = script_path:gsub("\\", "/")
local litmd_home = script_path:match(".*/")
-- print("litmd_home: " .. litmd_home)

--- Show usage
local function show_usage()
  print("Usage: litmd <inputfile.md> [options]")
end

-- if no arguments are provided, print the usage
if #args == 0 then
  show_usage()
  return
end

-- get the input file name
local input_file = args[1]
if input_file == nil then
  print("No input file provided")
  show_usage()
  return
end

-- get the rest of the arguments
local options = {}
for i = 2, #args do
  table.insert(options, args[i])
end
```

### Construct and Display Pandoc Command

In the next section of the program we now construct the pandoc command to run
such that both the output document, and output code are generated correctly.

* The `TANGLE_FILTER` variable is created to store the path to the lua pandoc
  filter which will extract the code from the input document and write it to
  individual source code files.
* The `PANDOC_CMD` variable stores a string which passes the lua-filter arg and
  the markdown source type setting to the pandoc command.
* Then we construct the command to be run in a variable called `cmd` from its
  constituent parts. First the `PANDOC_CMD` then the `input_file` and finally
  the rest of the args in the table `options` are added to the string `cmd`.
* Once constructed the `cmd` string is displayed on the terminal.

```lua {code_file="litpd.lua"}

local TANGLE_FILTER = litmd_home .. "mdtangle.lua"
local PANDOC_CMD = "pandoc --lua-filter=" .. TANGLE_FILTER .. " --from=markdown "

-- create the final command, start with the pandoc command
local cmd = PANDOC_CMD
-- add the input file
cmd = cmd .. input_file
-- add the rest of the options
for i = 1, #options do
  cmd = cmd .. " " .. options[i]
end

-- display the command to be executed
print("Executing: " .. cmd)
```

### Run the Pandoc Command

The last few lines of the program run the constructed `cmd` string using
the `io.popen` library call. The call returns a handle to the output, which is
stored in `handle`. We read the output from this output stream into a variable
called `result` and then close the `handle`.

The `result` is printed to the terminal. And then the program is done.

```lua {code_file="litpd.lua"}

-- execute the command
local handle = io.popen(cmd)
if handle == nil then
  print("Error executing command")
  return
end
local result = handle:read("*a")
handle:close()
-- handle the result
print(result)
```

## Filter Program - mdtangle.lua

```lua {code_file="mdtangle.lua"}
--- md-tangle.lua - Lua filter for pandoc to tangle code blocks into one or more
-- files.
--
-- license: MIT see LICENSE file
-- date: 21/03/2024
-- author: Abhishek Mishra

local tangle = {}

local function get_file_name (code_block)
  local file_name = code_block.attributes["code_file"]
  if file_name == nil then
    file_name = "Untitled.lua"
  end
  return file_name
end

local function get_file (code_block)
  local full_path = get_file_name(code_block)
  local file = io.open(full_path, "a")
  return full_path, file
end

local function write_code_block (code_block, file)
  local code = code_block.text
  file:write(code)
  file:write("\n")
end

local function close_file (file)
  file:close()
end

function tangle.CodeBlock (code_block)
  local full_path, file = get_file(code_block)
  print("Tangling code block at " .. full_path)
  write_code_block(code_block, file)
  close_file(file)
end

return {
  tangle
}
```