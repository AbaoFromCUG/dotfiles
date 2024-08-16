local function cmake()
    local osys = require("cmake-tools.osys")
    require("cmake-tools").setup({
        cmake_command = "cmake", -- this is used to specify cmake command path
        ctest_command = "ctest", -- this
        cmake_build_directory = function()
            return "build/${variant:buildType}"
        end,
        cmake_executor = {
            name = "overseer",

            opts = {
                new_task_opts = {
                    strategy = {
                        "toggleterm",
                        direction = "horizontal",
                        autos_croll = true,
                        quit_on_exit = "never",
                    },
                },
            },
        },
    })
end

local function neopyter()
    require("neopyter").setup({
        remote_address = "127.0.0.1:9001",
        auto_attach = true,
        on_attach = function(buf)
            require("which-key").add({
                { "<space>nt", "<cmd>Neopyter execute kernelmenu:restart<cr>", desc = "restart kernel", buffer = buf },
                { "<C-Enter>", "<cmd>Neopyter execute notebook:run-cell<cr>", desc = "run selected", buffer = buf },
                { "<space>nr", "<cmd>Neopyter execute notebook:run-cell<cr>", desc = "run selected", buffer = buf },
                { "<F5>", "<cmd>Neopyter execute notebook:restart-run-all<cr>", desc = "restart kernel and run all", buffer = 0 },
            })
        end,
        highlight = {
            enable = true,
            shortsighted = false,
        },
        jupyter = {
            scroll = {
                enable = true,
                align = "auto",
            },
        },
        parser = {
            trim_whitespace = true,
        },
    })
end

---@type LazySpec[]
return {
    {
        "Civitasv/cmake-tools.nvim",
        config = cmake,
        cmd = { "CMakeGenerate", "CMakeBuild", "CMakeRun", "CMakeSettings", "CMakeTargetSettings" },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "SUSTech-data/neopyter",
        config = neopyter,
        ft = { "python" },
        cmd = "Neopyter",
        dev = true,
    },
    {
        "glacambre/firenvim",
        build = ":call firenvim#install(0)",
    },
    { "LunarVim/bigfile.nvim", opts = {}, lazy = false },
    {
        "luckasRanarison/tailwind-tools.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ---@type TailwindTools.Option
        opts = {},
        ft = { "html", "typescript", "typescriptreact", "vue" },
    },
    { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } },
    { "h-hg/fcitx.nvim", event = "InsertEnter" },
    {
        "mistweaverco/kulala.nvim",
        ft="http"
    },
}
