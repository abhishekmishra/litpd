require 'busted.runner'()

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

---@diagnostic disable: undefined-field, need-check-nil
describe("test a literate program with no code file", function()
    local output_file = "out/test0-onlycode.html"

    it("should generate " .. output_file, function()
        -- delete the output file if it exists
        os.remove(output_file)

        -- Run litpd.lua on test0-onlycode.md
        local cmd = "lua dist/litpd.lua test/data/test0-onlycode.md --to=html"
        cmd = cmd .. " -o " .. output_file
        os.execute(cmd)

        -- Check if test0-onlycode.html is generated
        assert.is_true(exists(output_file))
    end)
end)

describe("test a literate program with code file", function()
    local output_file = "out/test1-codewfname.html"
    local code_file = "out/helloworld.lua"

    it("should generate " .. output_file, function()
        -- delete the output file if it exists
        os.remove(output_file)
        os.remove(code_file)

        -- Run litpd.lua on test1-onlycode.md
        local cmd = "lua dist/litpd.lua test/data/test1-codewfname.md --to=html"
        cmd = cmd .. " -o " .. output_file
        os.execute(cmd)

        -- Check if test1-onlycode.html is generated
        assert.is_true(exists(output_file))
        assert.is_true(exists(code_file))
    end)
end)

describe("test a literate program with code ids", function()
    local output_file = "out/test2-codeids.html"
    local code_id1 = "fnsay.tmp"
    local code_id2 = "sayhello.tmp"

    it("should generate " .. output_file, function()
        -- delete the output file if it exists
        os.remove(output_file)
        os.remove(code_id1)
        os.remove(code_id2)

        -- Run litpd.lua on test1-onlycode.md
        local cmd = "lua dist/litpd.lua test/data/test2-codeids.md --to=html"
        cmd = cmd .. " -o " .. output_file
        os.execute(cmd)

        assert.is_true(exists(output_file))
        assert.is_true(exists(code_id1))
        assert.is_true(exists(code_id2))

        -- delete the code files
        os.remove(code_id1)
        os.remove(code_id2)
    end)
end)

describe("test a program containing code id references", function()
    local output_file = "out/test3-codeids.html"
    local code_id1 = "fnsay.tmp"
    local code_id2 = "sayhello.tmp"
    local code_file = "hello3.lua"

    it("should generate " .. output_file, function()
        -- delete the output file if it exists
        os.remove(output_file)
        os.remove(code_id1)
        os.remove(code_id2)
        os.remove(code_file)

        -- Run litpd.lua on test1-onlycode.md
        local cmd = "lua dist/litpd.lua test/data/test3-codeid-use.md --to=html"
        cmd = cmd .. " -o " .. output_file
        os.execute(cmd)

        assert.is_true(exists(output_file))
        assert.is_true(exists(code_id1))
        assert.is_true(exists(code_id2))

        -- delete the code files
        os.remove(output_file)
        os.remove(code_id1)
        os.remove(code_id2)
        os.remove(code_file)
    end)
end)

describe("test a program containing two code id references", function()
    local output_file = "out/test4-codeids.html"
    local code_id1 = "fnsay.tmp"
    local code_id2 = "sayhello.tmp"
    local code_file = "hello3.lua"

    it("should generate " .. output_file, function()
        -- delete the output file if it exists
        os.remove(output_file)
        os.remove(code_id1)
        os.remove(code_id2)
        os.remove(code_file)

        -- Run litpd.lua on test1-onlycode.md
        local cmd = "lua dist/litpd.lua test/data/test4-codeid-use.md --to=html"
        cmd = cmd .. " -o " .. output_file
        os.execute(cmd)

        -- Get contents of the output file
        local file = io.open(code_file, "r")
        local contents = file:read("*a")
        file:close()

        -- ensure that the code ids are replaced

        assert.not_nil(string.find(contents, "function do"))

        assert.is_true(exists(output_file))
        assert.is_true(exists(code_id1))
        assert.is_true(exists(code_id2))

        -- delete the code files
        -- os.remove(output_file)
        os.remove(code_id1)
        os.remove(code_id2)
        os.remove(code_file)
    end)
end)