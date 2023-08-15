local function luasnip()
    local snippet_path = vim.fn.stdpath("config") .. "/snippets"
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippet_path } })
    require("luasnip.loaders.from_vscode").lazy_load()
end

local function signature()
    local lsp_signature = require("lsp_signature")
    lsp_signature.setup({
        floating_window_above_cur_line = false,
    })
end

return {
    -- completion engine
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = require("plugins.lsp.cmp"),
    },
    {
        "L3MON4D3/LuaSnip",
        -- windows don't support luajit
        build = "make install_jsregexp",
        config = luasnip,
    },
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "ray-x/cmp-treesitter",
    "paopaol/cmp-doxygen",
    -- show signature
    { "ray-x/lsp_signature.nvim", config = signature },
    -- pictograms for lsp
    { "onsails/lspkind-nvim" },
    -- diagnostic list
    { "folke/trouble.nvim", config = require("plugins.lsp.trouble") },
    {
        "creativenull/efmls-configs-nvim",
        dependencies = { "neovim/nvim-lspconfig" },
    },
    { "folke/neodev.nvim", config = true },

    { "neovim/nvim-lspconfig", config = require("plugins.lsp.lspconfig") },
}
