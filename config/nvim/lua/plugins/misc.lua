local function toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd([[setlocal ve=all]])
        vim.keymap.set("n", "J", "<C-v>j:VBox<CR>")
        vim.keymap.set("n", "K", "<C-v>k:VBox<CR>")
        vim.keymap.set("n", "L", "<C-v>l:VBox<CR>")
        vim.keymap.set("n", "H", "<C-v>h:VBox<CR>")
        vim.keymap.set("v", "f", ":VBox<CR>")
    else
        vim.cmd([[setlocal ve=]])
        vim.keymap.del("n", "J", { buffer = 0 })
        vim.keymap.del("n", "K", { buffer = 0 })
        vim.keymap.del("n", "L", { buffer = 0 })
        vim.keymap.del("n", "H", { buffer = 0 })
        vim.keymap.del("v", "f", { buffer = 0 })
        vim.b.venn_enabled = nil
    end
end

---@type LazySpec[]
return {
    {
        "Civitasv/cmake-tools.nvim",
        event = function()
            if vim.fn.filereadable(vim.fs.joinpath(vim.uv.cwd(), "CMakeLists.txt")) == 1 then
                return { "VeryLazy" }
            end
            return {}
        end,
        opts = {
            cmake_command = "cmake", -- this is used to specify cmake command path
            ctest_command = "ctest", -- this
            cmake_build_directory = function() return "build/${variant:buildType}" end,
            cmake_dap_configuration = {
                name = "Launch CMake target",
                type = "cppdbg",
                setupCommands = {
                    {
                        text = "-enable-pretty-printing",
                        description = "enable pretty printing",
                        ignoreFailures = false,
                    },
                },
            },
            cmake_executor = {
                name = "overseer",
                opts = {
                    new_task_opts = {
                        strategy = {
                            "toggleterm",
                            direction = "horizontal",
                            auto_scroll = true,
                            quit_on_exit = "success",
                            -- use_shell = true,
                        },
                    },
                    on_new_task = function() end,
                },
            },
            cmake_runner = {
                name = "overseer",

                opts = {
                    new_task_opts = {
                        strategy = {
                            "toggleterm",
                            direction = "float",
                            auto_scroll = true,
                            quit_on_exit = "never",
                            -- use_shell = true,
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            require("which-key").add({
                { "<leader>o", group = true, desc = "cmake" },
                { "<leader>os", "<cmd>CMakeSettings<cr>", desc = "cmake settings" },
                { "<leader>og", "<cmd>CMakeGenerate<cr>", desc = "cmake generate" },
                { "<leader>ob", "<cmd>CMakeBuild<cr>", desc = "cmake build" },
                { "<leader>od", "<cmd>CMakeDebug<cr>", desc = "cmake debug" },
                { "<leader>or", "<cmd>CMakeRun<cr>", desc = "cmake run" },
            })
            require("cmake-tools").setup(opts)
        end,
        cmd = {
            "CMakeGenerate",
            "CMakeBuild",
            "CMakeRun",
            "CMakeDebug",
            "CMakeSettings",
            "CMakeTargetSettings",
        },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        ft = { "markdown" },
    },
    {
        "iamcco/markdown-preview.nvim",
        build = function() vim.fn["mkdp#util#install"]() end,
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        keys = {},
        ft = "markdown",
    },
    {
        "glacambre/firenvim",
        build = ":call firenvim#install(0)",
    },
    { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } },
    { "h-hg/fcitx.nvim", event = "InsertEnter" },
    {
        "mistweaverco/kulala.nvim",
        ft = "http",
    },
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        build = function() require("typst-preview").update() end,
        opts = {
            dependencies_bin = {
                ["tinymist"] = vim.fn.exepath("tinymist"),
                ["websocat"] = vim.fn.exepath("websocat"),
            },
            -- debug = true,
        },
    },
    {
        "mistricky/codesnap.nvim",
        build = "make",
        cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapASCII" },
        opts = {
            has_line_number = true,
            bg_theme = "bamboo",
        },
        keys = {
            { "<leader>tc", desc = "code snapshot" },
            { "<leader>tcs", "<cmd>CodeSnap<cr>", mode = "x", desc = "save code snapshot into clipboard" },
            { "<leader>tcc", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "save code snapshot in ~/Pictures" },
        },
    },
    {
        "jbyuki/venn.nvim",
        cmd = "VBox",
        keys = {
            { "<leader>td", toggle_venn, desc = "draw diagrams" },
        },
    },
    {
        "uga-rosa/translate.nvim",
        cmd = "Translate",
        keys = {
            { "<leader>tt", "<Cmd>Translate ZH<CR>", mode = { "n", "x" }, desc = "translate" },
        },
        opts = {
            default = {
                command = "translate_shell",
            },
            preset = {
                output = {
                    split = {
                        append = true,
                    },
                },
            },
        },
    },
    { "towolf/vim-helm", lazy = false },

    {
        "tpope/vim-dadbod",
        dependencies = {
            "kristijanhusak/vim-dadbod-completion",
            "kristijanhusak/vim-dadbod-ui",
        },
        cmd = {
            "DB",
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function() vim.g.db_ui_save_location = vim.uv.cwd() end,
        keys = {
            { "<leader>tss", "<cmd>DBUI<cr>" },
        },
    },
}
