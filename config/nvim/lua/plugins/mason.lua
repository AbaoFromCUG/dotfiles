return function()
    require("mason").setup {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    }
    require("mason-lspconfig").setup {
        ensure_installed = {
            'clangd',
            'cmake',
            'tsserver',
            'sumneko_lua',
            'vimls',
            'bashls',
            'yamlls',
            'pyright',
            'autopep8',
        }
    }
end