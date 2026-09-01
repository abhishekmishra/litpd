--- litpd_filter.lua - Pandoc filter for tangling literate-program source files.
-- license: MIT see LICENSE file
-- author: Abhishek Mishra

local fragments = {}
local written_files = {}

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

function Pandoc(doc)
    collect_fragments(doc)
    return doc:walk({CodeBlock = label_code_block})
end
