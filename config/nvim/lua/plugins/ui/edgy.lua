return function()
    require("edgy").setup({
        left = {
            {
                title = "NvimTree",
                ft = "NvimTree",
                pinned = true,
                open = "NvimTreeOpen",
            },
            -- any other neo-tree windows
            "neo-tree",
        },
        right = {
            {
                ft = "aerial",
                pinned = true,
                -- open = "AerialToggle right",
            },
            {
                ft = "help",
                size = { width = 120 },
                -- only show help buffers
                filter = function(buf) return vim.bo[buf].buftype == "help" end,
            },
        },
        bottom = {
            {
                ft = "toggleterm",
                size = { height = 0.4 },
                -- exclude floating windows
                filter = function(buf, win) return vim.api.nvim_win_get_config(win).relative == "" end,
            },
            {
                ft = "trouble",
                title = "Trouble",
                size = { height = 0.4 },
            },
            { ft = "qf", title = "QuickFix" },
            { ft = "spectre_panel", size = { height = 0.4 } },
            { ft = "httpResult", size = { height = 0.4 } },
        },
    })
end
