local function neotest()
    local vitest_original_is_test_file = require("neotest-vitest").is_test_file
    local python_adapter = require("neotest-python")({
        python = require("lib.python").get_python_path(),
    })
    local python_root = python_adapter.root
    python_adapter.root = function(path)
        local p = python_root(vim.api.nvim_buf_get_name(0)) or python_root(path) or vim.loop.cwd()
        return p
    end

    ---@diagnostic disable-next-line: missing-fields
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
            require("neotest-vitest")({
                vitestCommand = "bunx vitest",
                is_test_file = function(file_path)
                    if vitest_original_is_test_file(file_path) then
                        return true
                    end

                    return string.match(file_path, "tests")
                end,
            }),
            require("neotest-gtest").setup({
                debug_adapter = "cppdbg",
            }),
        },
        ---@diagnostic disable-next-line: assign-type-mismatch
        consumers = { overseer = require("neotest.consumers.overseer") },
    })
end

return {

    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-neotest/neotest-jest",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-python",
            "marilari88/neotest-vitest",
            {

                "alfaix/neotest-gtest",
            },
        },
        keys = {
            {
                "<space>tt",
                function()
                    if vim.bo.filetype == "cpp" or vim.bo.filetype == "c" then
                        vim.cmd("CMakeBuild")
                        vim.defer_fn(function() vim.cmd("Neotest run") end, 1000)
                    else
                        vim.cmd("Neotest run")
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
                        vim.cmd("Neotest run")
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
