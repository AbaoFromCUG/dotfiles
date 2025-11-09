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
