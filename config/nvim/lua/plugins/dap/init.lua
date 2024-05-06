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
            require("neotest-python"),
            require("neotest-jest")({
                jestCommand = "npm test --",
                jestConfigFile = "custom.jest.config.ts",
                env = { CI = true },
                cwd = function(path)
                    return vim.fn.getcwd()
                end,
            }),
        },
        consumers = { overseer = require("neotest.consumers.overseer") },
    })
    vim.keymap.set("n", "<space>tf", function()
        neotest.run.run(vim.fn.expand("%"))
    end, { desc = "test current file" })
    vim.keymap.set("n", "<space>tt", function()
        neotest.run.run()
    end, { desc = "test nearest case" })
end

return {
    {
        "mfussenegger/nvim-dap",
        config = require("plugins.dap.dap"),
        lazy = true,
        event = "VeryLazy",
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-dap",
        config = require("plugins.dap.dapui"),
        lazy = true,
    },
    { "theHamsta/nvim-dap-virtual-text", config = true, lazy = true },
    { "Weissle/persistent-breakpoints.nvim", config = true, lazy = true, event = "VeryLazy" },

    { "stevearc/overseer.nvim", dev = true, config = overseer, lazy = true, event = "VeryLazy" },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-nio",
            "plenary.nvim",
            "nvim-treesitter",
            "neotest-jest",
            "neotest-plenary",
        },
        config = neotest,
        lazy = true,
        event = "VeryLazy",
    },
    { "AbaoFromCUG/neotest-plenary", branch = "abao/fix_async" },
    { "nvim-neotest/neotest-jest" },
    "nvim-neotest/neotest-python",
}
