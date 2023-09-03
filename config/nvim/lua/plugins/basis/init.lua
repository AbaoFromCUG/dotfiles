local function mason()
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    })
end

local function mason_lspconfig()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
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
        },
        automatic_installation = true,
    })
end

local function mason_dap()
    require("mason-nvim-dap").setup({
        ensure_installed = { "python", "cppdbg" },
        automatic_installation = true,
    })
end

return {
    "nvim-lua/plenary.nvim",
    "rktjmp/fwatch.nvim",
    "nvim-lua/popup.nvim",
    "tami5/sqlite.lua",
    "nvim-tree/nvim-web-devicons",
    {
        "folke/which-key.nvim",
        lazy = true,
        config = true,
    },
    -- installer
    { "williamboman/mason.nvim", config = mason },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "mason.nvim",
        config = mason_lspconfig,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        config = mason_dap,
    },
}
