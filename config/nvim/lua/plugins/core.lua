return {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "tami5/sqlite.lua",
    "nvim-tree/nvim-web-devicons",
    "pysan3/pathlib.nvim",
    "AbaoFromCUG/websocket.nvim",

    -- installer
    { "williamboman/mason.nvim", config = true },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "mason.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "lua_ls",
                "pyright",
                "vimls",
                "bashls",
                "clangd",
                "jsonls",
                "yamlls",
                "neocmake",
                "html",
                "cssls",
                "tsserver",
                "volar",
                "texlab",
                "marksman",
                "taplo",
                "ruff_lsp",
                "tailwindcss",
                "eslint",
                "rust_analyzer",
                "stylelint_lsp",
            },
            automatic_installation = true,
        },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        opts = {
            ensure_installed = { "cppdbg" },
            automatic_installation = true,
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        opts = {
            ensure_installed = {},
            automatic_installation = true,
        },
    },
}
