local function overseer()
    require("dap.ext.vscode").json_decode = require("overseer.json").decode
    require("overseer").setup({
        templates = { "builtin" },
        strategy = {
            "toggleterm",
            direction = "float",
            -- use_shell = true,
        },
    })
end

local function neotest()
    require("neotest").setup({
        adapters = {
            require("neotest-plenary"),
        },
        consumers = {
            overseer = require("neotest.consumers.overseer"),
        },
    })
end

return {
    {
        "mfussenegger/nvim-dap",
        config = require("plugins.dap.dap"),
    },
    {
        "AbaoFromCUG/integrator.nvim",
        dev = true,
        opts = {
            dap = { enabled = true },
            session = { enabled = true },
            settings = { enabled = true },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-dap",
        config = require("plugins.dap.dapui"),
    },
    { "theHamsta/nvim-dap-virtual-text", config = true },
    { "Weissle/persistent-breakpoints.nvim", config = true },

    { "stevearc/overseer.nvim", dev = true, config = overseer },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = neotest,
    },
    { "nvim-neotest/neotest-plenary", dev = true },
}
