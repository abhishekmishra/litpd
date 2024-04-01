require 'busted.runner'()

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
        local file = io.open(output_file, "r")
        assert.is_not_nil(file, output_file .. " is not generated")
        file:close()
    end)
end)