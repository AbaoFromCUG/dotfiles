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

local function _null_ls()
    local null_ls = require("null-ls")
    null_ls.setup({
        debug = true,
        sources = {
            null_ls.builtins.diagnostics.qmllint,
            null_ls.builtins.formatting.qmlformat,
            null_ls.builtins.formatting.autopep8,
            null_ls.builtins.formatting.cmake_format,
            null_ls.builtins.formatting.shfmt.with({
                filetypes = { "sh", "zsh", "bash" },
            }),
            null_ls.builtins.formatting.yamlfmt,
            null_ls.builtins.formatting.stylua.with({
                condition = function(utils)
                    return utils.root_has_file({ "stylua.toml", ".editorconfig", ".stylua.toml" })
                end,
            }),

            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.formatting.eslint,
        },
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
    -- { "jose-elias-alvarez/null-ls.nvim", config = _null_ls },

    { "neovim/nvim-lspconfig", config = require("plugins.lsp.lspconfig") },
}
