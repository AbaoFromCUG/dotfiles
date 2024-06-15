local which_key = require("which-key")

local function goto_define()
    local line = vim.api.nvim_get_current_line()
end

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
