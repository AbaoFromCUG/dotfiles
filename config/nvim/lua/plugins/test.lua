---@diagnostic disable: missing-fields, param-type-mismatch


local function neotest()
    local python_adapter = require("neotest-python")({
        python = require("utils.python").get_python_path(),
    })
    local python_root = python_adapter.root
    python_adapter.root = function(path)
        local p = python_root(vim.api.nvim_buf_get_name(0)) or python_root(path) or vim.uv.cwd()
        return p
    end

    require("neotest").setup({
        log_level = vim.log.levels.INFO,
        adapters = {
            require("neotest-plenary"),
            python_adapter,
            require("neotest-jest")({
                jestCommand = "npm test --",
                jestConfigFile = "custom.jest.config.ts",
                env = { CI = true },
                cwd = function() return vim.fn.getcwd() end,
            }),
            require("neotest-vitest")({}),
            require("neotest-playwright").adapter({
                options = {
                    persist_project_selection = true,
                    enable_dynamic_test_discovery = true,
                },
            }),
            require("neotest-gtest").setup({
                debug_adapter = "cppdbg",
            }),
        },
        ---@diagnostic disable-next-line: assign-type-mismatch
        consumers = {
            overseer = require("neotest.consumers.overseer"),
            playwright = require("neotest-playwright.consumers").consumers,
        },
    })
end

return {

    {
        "nvim-neotest/neotest",
        dev = true,
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-neotest/neotest-jest",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-python",
            { "AbaoFromCUG/neotest-vitest",     dev = true },
            { "AbaoFromCUG/neotest-playwright", dev = true },
            "alfaix/neotest-gtest",
        },
        keys = {
            { "<space>ta", function() require("nio").run(function() require("neotest").playwright.attachment() end) end, desc = "test attachment launch", },
            { "<space>ts", "<cmd>Neotest summary<cr>",                                                                   desc = "test summary" },
            {
                "<space>tt",
                function()
                    if vim.bo.filetype == "cpp" or vim.bo.filetype == "c" then
                        vim.cmd("CMakeBuild")
                        vim.defer_fn(function() vim.cmd("Neotest run") end, 1000)
                    else
                        local task = require("nio").run(function()
                            require("neotest").run.run()
                        end)
                    end
                end,
                desc = "test nearest case",
            },
            {
                "<space>tf",
                function()
                    if vim.bo.filetype == "cpp" or vim.bo.filetype == "c" then
                        vim.cmd("CMakeBuild")
                        vim.defer_fn(function() require("neotest").run.run(vim.fn.expand("%")) end, 1000)
                    else
                        require("neotest").run.run(vim.fn.expand("%"))
                    end
                end,
                desc = "test current file",
            },

            { "[n", "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", desc = "previous failed test" },
            { "]n", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", desc = "next failed test" },
        },
        config = neotest,
        cmd = "Neotest",
    },
}
