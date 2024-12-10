local function cmake()
    local osys = require("cmake-tools.osys")
    require("cmake-tools").setup({
        cmake_command = "cmake", -- this is used to specify cmake command path
        ctest_command = "ctest", -- this
        cmake_build_directory = function() return "build/${variant:buildType}" end,
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
                { "<space>nt", "<cmd>Neopyter execute kernelmenu:restart<cr>", desc = "restart kernel" },
                { "<C-CR>", "<cmd>Neopyter execute notebook:run-cell<cr>", desc = "run selected" },
                { "<space>nr", "<cmd>Neopyter execute notebook:run-cell<cr>", desc = "run selected" },
                { "<F5>", "<cmd>Neopyter execute notebook:restart-run-all<cr>", desc = "restart kernel and run all" },

                buffer = buf,
            })
        end,
        highlight = {
            enable = false,
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
        config = cmake,
        cmd = { "CMakeGenerate", "CMakeBuild", "CMakeRun", "CMakeSettings", "CMakeTargetSettings" },
        keys = {
            { "<leader>,c", "<cmd>CMakeSettings<cr>", desc = "cmake settings" },
            { "<space>cg", "<cmd>CMakeGenerate<cr>", desc = "cmake generate" },
            { "<space>cb", "<cmd>CMakeBuild<cr>", desc = "cmake generate" },
        },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        ft = "markdown",
    },
    {
        "SUSTech-data/neopyter",
        config = neopyter,
        opts ={

        },
        ft = { "python" },
        enabled = true,
        cmd = "Neopyter",
        dev = true,
    },
    {
        "glacambre/firenvim",
        build = ":call firenvim#install(0)",
    },
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
        ft = "http",
    },
    {
        "lervag/vimtex",
        ft = { "tex", "latex" },
        init = function() vim.g.vimtex_view_method = "zathura" end,
    },
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "0.3.*",
        build = function() require("typst-preview").update() end,
        opts = {
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
            { "<leader>tt", "<Cmd>Translate zh-CN<CR>", mode = { "n", "x" }, desc = "translate" },
        },
    },
    { "qvalentin/helm-ls.nvim", ft = "helm" },
}
