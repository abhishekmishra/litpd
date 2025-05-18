<!-- vim: set tw=80: -->

# litpd

Tools for literate programming using pandoc's markdown format.

* Write a program and its design/description in one markdown document.
* Generate a printable/publishable document from the markdown document.
* Generate one or more programs from the markdown document which can be used to
  run the program.

This program is written as a "literate program" in markdown. See
[litpd.md](litpd.md).

# Getting Started

**litpd** is a command-line application to be used in your own build or document
generation process.

See the [Getting Started](https://abhishekmishra.github.io/litpd/#getting-started) page.

## Build

**Pre-requisites for build:**

1. Lua interpreter in path.
2. gnu make in path.
3. Pandoc in path.

In the directory containing the **litpd** source, run the following command:

```bash
$ make clean all
```

This will create a **dist** directory and generate all the build artifacts in
this directory.

## Example

If the markdown program is a simple hello world like this one...

**hello.md**

*notice the options to the code block inside curly braces.*

<pre>
# Hello World!

This is a simple hello world program in lua.

```lua { code_file = "hello.lua" }
print('hello')
```
</pre>

If we run the following litpd command...

```bash
# Windows
litpd.ps1 hello.md

# Linux/MacOS
litpd.sh hello.md
```

Two files will be generated in the current folder:

1. **program.html** - the markdown document converted to html by pandoc.
2. **hello.lua** - the program with the source code in the code block.
