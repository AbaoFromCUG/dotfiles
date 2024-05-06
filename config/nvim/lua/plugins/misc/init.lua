local function femaco()
    require("femaco").setup({
        create_tmp_filepath = function(filetype)
            return string.format("%s/.femaco_%d_%s", vim.fn.getcwd(), math.random(100, 999), filetype)
        end,
    })
end

local function neorg()
    require("neorg").setup({
        load = {
            ["core.defaults"] = {},
            ["core.journal"] = {
                config = {
                    workspace = "notes",
                },
            },

            ["core.completion"] = { config = { engine = "nvim-cmp" } },
            ["core.concealer"] = {},
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/Documents/notes",
                    },
                    autochdir = true,
                    index = "index.norg",
                },
            },
            ["core.export"] = {},
            ["core.export.markdown"] = {},
            ["core.presenter"] = {
                config = {
                    zen_mode = "truezen",
                },
            },
        },
    })
end

return {
    {
        "AbaoFromCUG/cmake-tools.nvim",
    },
    { "Saecki/crates.nvim", opts = {} },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        -- build = "cd app && yarn install",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "AckslD/nvim-FeMaco.lua",
        ft = "markdown",
        config = femaco,
    },
    {
        "nvim-neorg/neorg",
        cmd = { "Neorg" },
        version = "v7.0.0",
        config = neorg,
    },
    {
        "SUSTech-data/neopyter",
        cmd = { "Neopyter" },
        ft = { "python" },
        lazy = true,
        enable = false,
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
        },
    },
    { "rafcamlet/nvim-luapad" },
    {
        "glacambre/firenvim",
        build = function()
            vim.fn["firenvim#install"](0)
        end,
    },
    "LunarVim/bigfile.nvim",
    {
        "luckasRanarison/tailwind-tools.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ---@type TailwindTools.Option
        opts = {},
        lazy = true,
    },
    { "lambdalisue/suda.vim" },
    { "h-hg/fcitx.nvim" },
    { "AbaoFromCUG/luals.nvim", config = true, lazy = true },
}
