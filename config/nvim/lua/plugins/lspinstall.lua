return function()
    local lsp_installer = require "nvim-lsp-installer"

    lsp_installer.settings {
        ensure_installed = {
            'clangd',
            'cmake',
            'tsserver',
            'sumneko_lua',
            'vimls',
            'bashls',
        },
        ui = {
            icons = {
                server_installed = "✓",
                server_pending = "➜",
                server_uninstalled = "✗",
            },
        },
    }
end
