--- litpd.lua - Main CLI program for litpd tool.
--
-- license: MIT see LICENSE file
-- date: 21/03/2024
-- author: Abhishek Mishra

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
