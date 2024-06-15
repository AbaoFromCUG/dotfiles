local function neopyter()
    require("neopyter").setup({
        remote_address = "127.0.0.1:9001",
        auto_attach = true,
        on_attach = function(buf)
            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = buf })
            end

            map("n", "<space>nt", "<cmd>Neopyter execute kernelmenu:restart<cr>", "restart kernel")

            map("n", "<C-Enter>", "<cmd>Neopyter execute notebook:run-cell<cr>", "run selected")

            map("n", "<F5>", "<cmd>Neopyter execute notebook:restart-run-all<cr>", "restart kernel and run all")
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
        dependencies = { "luarocks.nvim" },
        config = true,
        main = "rest-nvim",
        cmd = { "Rest" },
        ft = "http",
    },
}
