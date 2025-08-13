---@type LazySpec[]
return {
    {
        "kawre/leetcode.nvim",
        lazy = false,
        cond = vim.fn.argv(0, -1) == "leetcode.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            ---@type lc.picker
            picker = { provider = "snacks-picker" },
            storage = {
                home = vim.fs.normalize("~/Documents/leetcode")
            },
            plugins = {
                non_standalone = true,
            },
            editor = {
                reset_previous_code = false,
            },
            injector = {
                ["cpp"] = {
                    imports = function(status)
                        vim.print(status)
                        -- return a different list to omit default imports
                        return { "#include <bits/stdc++.h>", "using namespace std;" }
                    end,
                    after = function(status)
                        vim.print(status)
                        return "int main() {}"
                    end,
                }
            }
        },
    }

}
