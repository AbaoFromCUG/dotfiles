vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "❌",
            [vim.diagnostic.severity.WARN] = "⚠️",
            [vim.diagnostic.severity.INFO] = "ℹ️",
            [vim.diagnostic.severity.HINT] = "❓",
        },
    },
})
return {
    {
        "stevearc/quicker.nvim",
        event = "FileType qf",
        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {},
        keys = {
            { "<leader>qq", function() require("quicker").toggle() end,                   desc = "Toggle quickfix" },
            { "<leader>ql", function() require("quicker").toggle({ loclist = true }) end, desc = "Toggle loclist" }
        }
    }
}
