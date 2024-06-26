
local codeidextract = {}

local function get_file_name (code_block)
    if code_block.attributes["code_id"] then
        return code_block.attributes["code_id"] .. '.tmp'
    end
end

local function get_file (code_block)
    local full_path = get_file_name(code_block)
    if full_path == nil then
        return nil, nil
    end
    local file = io.open(full_path, "w")
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

function codeidextract.CodeBlock (code_block)
    local full_path, file = get_file(code_block)
    if full_path == nil then
        return
    end
    print("Extracting code id at " .. full_path)
    write_code_block(code_block, file)
    close_file(file)

    -- create a label for the code block if id exists
    local label_text = "id: " .. code_block.attributes["code_id"]
    return {
        pandoc.Strong(pandoc.Str(label_text)),
        code_block
    }
end

return {
    codeidextract
}
