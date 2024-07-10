local function smart_run()
    local dap = require("dap")
    if dap.session() then
        dap.continue()
    else
        dap.run_last()
    end
end

local function overseer()
    ---@diagnostic disable-next-line: missing-fields
    require("overseer").setup({
        templates = { "builtin" },
        ---@diagnostic disable-next-line: assign-type-mismatch
        strategy = {
            "toggleterm",
            direction = "float",
            use_shell = true,
        },
    })
end

local function neotest()
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
        adapters = {
            require("neotest-plenary"),
            require("neotest-python"),
            require("neotest-jest")({
                jestCommand = "npm test --",
                jestConfigFile = "custom.jest.config.ts",
                env = { CI = true },
                cwd = function()
                    return vim.fn.getcwd()
                end,
            }),
            require("neotest-vitest")({
                vitestCommand = "bunx vitest",
            }),
        },
        ---@diagnostic disable-next-line: assign-type-mismatch
        consumers = { overseer = require("neotest.consumers.overseer") },
    })
end

return {
    {
        "mfussenegger/nvim-dap",
        config = require("plugins.dap.dap"),
        keys = {
            { "<F5>", "<cmd>DapContinue<cr>", mode = { "n", "i" }, desc = "run" },
            { "<F6>", "<cmd>DapTerminate<cr>", mode = { "n", "i" }, desc = "terminate" },
            { "<F9>", "<cmd>PBToggleBreakpoint<cr>", mode = { "n", "i" }, desc = "toggle breakpoint" },
            { "<F11>", "<cmd>DapStepInto<cr>", mode = { "n", "i" }, desc = "step into" },
            { "<F12>", "<cmd>DapStepOver<cr>", mode = { "n", "i" }, desc = "step over" },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-dap",
        config = require("plugins.dap.dapui"),
    },
    { "theHamsta/nvim-dap-virtual-text", config = true },
    { "Weissle/persistent-breakpoints.nvim", config = true },
    {
        "stevearc/overseer.nvim",
        commit = "fdcd46ce738ef342bce38e5433df004ebdab3a1a",
        config = overseer,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-nio",
            "plenary.nvim",
            "nvim-treesitter",
            "neotest-jest",
            "neotest-plenary",
            { "marilari88/neotest-vitest", dev = true },
        },
        config = neotest,
        cmd = "Neotest",
        keys = {
            { "<space>tt", "<cmd>Neotest run<cr>", desc = "test nearest case" },
            { "<space>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "test current file" },
        },
    },
    {
        "nvim-neotest/neotest-plenary",
        -- "AbaoFromCUG/neotest-plenary",
        -- branch = "abao/fix_async",
        dev = true,
    },
    { "nvim-neotest/neotest-jest" },
    "nvim-neotest/neotest-python",
}
