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
        ---@type neopyter.Option
        opts = {
            remote_address = "127.0.0.1:9001",
            auto_attach = true,
            on_attach = function(buf)
                require("keymap.notebookbuf")(buf)
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
        },
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
    { "LunarVim/bigfile.nvim", event = "UIEnter" },
    {
        "luckasRanarison/tailwind-tools.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ---@type TailwindTools.Option
        opts = {},
        ft = { "html", "typescript", "typescriptreact", "vue" },
    },
    { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } },
    { "h-hg/fcitx.nvim", event = "VeryLazy" },
}
