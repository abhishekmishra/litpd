require 'busted.runner'()

---@diagnostic disable: undefined-field
describe("Dummy Test", function()
    it("should pass", function()
        -- Add your test logic here
        assert.is_true(true)
    end)
end)