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