local function neopyter()
    require("neopyter").setup({
        remote_address = "127.0.0.1:9001",
        auto_attach = true,
        on_attach = function(buf)
            local map = require("keymap")
            map({ "n", "<space>nt", "<cmd>Neopyter execute kernelmenu:restart<cr>", desc = "restart kernel", buffer = 0 })
            map({ "n", "<C-Enter>", "<cmd>Neopyter execute notebook:run-cell<cr>", desc = "run selected", buffer = 0 })
            map({ "n", "<space>nr", "<cmd>Neopyter execute notebook:run-cell<cr>", desc = "run selected", buffer = 0 })
            map({ "n", "<F5>", "<cmd>Neopyter execute notebook:restart-run-all<cr>", desc = "restart kernel and run all", buffer = 0 })
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
    })
end

---@type LazySpec[]
return {
    {
        "AbaoFromCUG/cmake-tools.nvim",
        event = "VeryLazy",
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
        build = function()
            vim.fn["firenvim#install"](0)
        end,
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
    { "h-hg/fcitx.nvim", event = "VeryLazy" },
    {
        "rest-nvim/rest.nvim",
        config = true,
        main = "rest-nvim",
        cmd = { "Rest" },
        ft = "http",
    },
}
