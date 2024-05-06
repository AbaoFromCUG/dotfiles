local which_key = require("which-key")

local function goto_define()
    local line = vim.api.nvim_get_current_line()
end

local line = "...ugins/integrator.nvim/tests/integrator/settings_spec.lua:58: Function was never called with matching arguments"

-- local regex = vim.regex("[...]\\w")
-- print(regex:match_str(line))
-- print(vim.inspect())

return function(bufno)
    which_key.register({
        ["<space>"] = {
            gd = { goto_define, "jump to source" },
        },
    }, {
        buffer = bufno,
        silent = false,
    })
end
