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
            -- use_shell = true,
        },
    })
    ---@diagnostic disable-next-line: duplicate-set-field
    require("overseer.shell").escape_cmd = function(cmd) return table.concat(vim.tbl_map(vim.fn.shellescape, cmd), " ") end
end

local function neotest()
    local vitest_original_is_test_file = require("neotest-vitest").is_test_file
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
        adapters = {
            require("neotest-plenary"),
            require("neotest-python"),
            require("neotest-jest")({
                jestCommand = "npm test --",
                jestConfigFile = "custom.jest.config.ts",
                env = { CI = true },
                cwd = function() return vim.fn.getcwd() end,
            }),
            require("neotest-vitest")({
                vitestCommand = "bunx vitest",
                is_test_file = function(file_path)
                    if vitest_original_is_test_file(file_path) then
                        return true
                    end

                    return string.match(file_path, "tests")
                end,
            }),
        },
        ---@diagnostic disable-next-line: assign-type-mismatch
        consumers = { overseer = require("neotest.consumers.overseer") },
    })
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "jay-babu/mason-nvim-dap.nvim" },
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
        config = overseer,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-neotest/neotest-jest",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-python",
            "marilari88/neotest-vitest",
        },
        keys = {
            { "<space>tt", "<cmd>Neotest run<cr>", desc = "test nearest case" },
            { "<space>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "test current file" },

            { "[n", "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", desc = "previous failed test" },
            { "]n", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", desc = "next failed test" },
        },
        config = neotest,
        cmd = "Neotest",
    },
}
