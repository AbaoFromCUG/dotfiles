local M = {}

function M.which_key()
    local which_key = require 'which-key'
    which_key.setup {}
end

function M.mason()
    require 'mason'.setup {
        ui = {
            icons = {
                package_installed = '✓',
                package_pending = '➜',
                package_uninstalled = '✗'
            }
        }
    }
end

function M.mason_lspconfig()
    require 'mason-lspconfig'.setup {
        ensure_installed = {
            'lua_ls',
            'vimls',
            'bashls',
            'clangd',
            'pyright',
            'jsonls',
            'yamlls',
            'neocmake',
            'html',
            'cssls',
            'tsserver',
            'volar',
        },
        automatic_installation = true,
    }
end

function M.mason_null_ls()
    require 'mason-null-ls'.setup {
        ensure_installed = {
            'autopep8',
            'shfmt',
            'yamlfmt',
        }
    }
end

function M.mason_dap()
    require 'mason-nvim-dap'.setup {
        ensure_installed = { 'python', 'cpptools', 'codelldb' }
    }
end

return M
