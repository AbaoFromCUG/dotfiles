local M = {}

function M.mason()
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

function M.mason_lspconfig()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "vimls",
            "bashls",
            "clangd",
            "pyright",
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

function M.mason_dap()
    require("mason-nvim-dap").setup({
        ensure_installed = { "python", "cppdbg" },
        automatic_installation = true,
    })
end

return M
