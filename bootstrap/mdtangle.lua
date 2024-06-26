--- md-tangle.lua - Lua filter for pandoc to tangle code blocks into one or more
-- files.
--
-- license: MIT see LICENSE file
-- date: 21/03/2024
-- author: Abhishek Mishra

local tangle = {}


local function get_file_name (code_block)
    return code_block.attributes["code_file"]
end

--- check if given path exists
---@param path string
---@return boolean
local function exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

--- file contents
--@param path string
--@return string contents
local function file_contents(path)
    local file = io.open(path, "r")
    local contents = nil
    if file then
        contents = file:read("*all")
        file:close()
    end
    return contents
end

local function get_file (code_block)
    local full_path = get_file_name(code_block)
    if full_path == nil then
        return nil, nil
    end
    local file = io.open(full_path, "a")
    return full_path, file
end

local function write_code_block (code_block, file)
    local code = code_block.text

    local code_id_replace = true

    while code_id_replace do
      local t = {}
      local i = 0
      local found_code_id = false

      while true do
          local code_id
          i, _, code_id = string.find(code, "@<(%a+)@>", i+1)
          if i == nil then break end
          table.insert(t,
            {
              index = i,
              code_id = code_id
            }
          )
          found_code_id = true
      end

      for _, v in ipairs(t) do
          print('code id found at ', v.index, ' code_id = ', v.code_id)
          local cidfile = v.code_id .. '.tmp'
          if exists(cidfile) then
              print('file for code_id', v.code_id, 'exists at', cidfile)
              local contents = file_contents(cidfile)
              -- print(contents)
              code = code:gsub("@<" .. v.code_id .. "@>", contents)
          end
      end

      -- repeat the search only if there is a code_id found in current
      -- iteration, which means there might be more after replacement
      if not found_code_id then
         code_id_replace = false
      end
    end

    file:write(code)
    -- print(code)
    file:write("\n")
end

local function close_file (file)
    file:close()
end

function tangle.CodeBlock (code_block)
    local full_path, file = get_file(code_block)
    if full_path == nil then
        return
    end
    print("Tangling code block at " .. full_path)
    write_code_block(code_block, file)
    close_file(file)

    local label_text = "file: " .. full_path
    return {
        pandoc.Strong(pandoc.Str(label_text)),
        code_block
    }
end

return {
    tangle
}
