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
end

return {
    {
        "mfussenegger/nvim-dap",
        config = require("plugins.dap.dap"),
    },
    {
        "AbaoFromCUG/integrator.nvim",
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
            "nvim-nio",
            "plenary.nvim",
            "nvim-treesitter",
            "neotest-jest",
            "neotest-plenary",
        },
        config = neotest,
    },
    { "AbaoFromCUG/neotest-plenary", branch="abao/fix_async" },
    { "nvim-neotest/neotest-jest" },
    "nvim-neotest/neotest-python",
}
