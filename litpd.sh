#!/bin/bash
#
# litpd.sh - Run the litpd program using the lua interpreter
#
# date: 18/05/2025
# author: Abhishek Mishra
#

show_usage() {
    echo "Usage: $0 <inputfile.md> [options]"
    echo "  Runs the litpd program using the lua interpreter."
    echo "  The input file should be a markdown file with code blocks."
    echo "  The argument and options will be passed on to the litpd program."
}

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Error: No input file provided"
    show_usage
    exit 1
fi

# Check if lua is available
if ! command -v lua >/dev/null 2>&1; then
    echo "Error: Lua interpreter not found"
    echo "Please make sure that the lua interpreter is installed and available in the PATH"
    exit 1
fi

# Check if pandoc is available
if ! command -v pandoc >/dev/null 2>&1; then
    echo "Error: Pandoc not found"
    echo "Please make sure that pandoc is installed and available in the PATH"
    exit 1
fi

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
lua_path="lua"
input_file="$1"
default_options="--output=program.html"

# Get options after input file
if [ $# -gt 1 ]; then
    shift
    options="$*"
else
    options=""
fi

# Set to default if options are empty
if [ -z "$options" ]; then
    options="$default_options"
fi

# Uncomment for debugging
# echo "Input File: $input_file"
# echo "Pandoc Options: $options"

"$lua_path" "$script_path/litpd.lua" "$input_file" $options