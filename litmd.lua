--- litmd.lua - Main program for lit-pandoc-md tool
--
-- license: MIT see LICENSE file
-- date: 21/03/2024
-- author: Abhishek Mishra

-- get the arguments from the command line
local args = {...}

-- if no arguments are provided, print the usage
if #args == 0 then
  print("Usage: litmd <weave|tangle> <inputfile.md> [options]")
  return
end

-- check if "weave" or "tangle" is provided as the first argument
local mode = args[1]
if mode ~= "weave" and mode ~= "tangle" then
  print("Invalid mode. Use 'weave' or 'tangle'")
  return
end

-- get the input file name
local input_file = args[2]
if input_file == nil then
  print("No input file provided")
  return
end

local TANGLE_FILTER = "mdtangle.lua"
local PANDOC_CMD = "pandoc --lua-filter=" .. TANGLE_FILTER .. " --from=markdown --to=html --standalone"
