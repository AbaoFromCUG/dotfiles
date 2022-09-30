local M = {}

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
            'clangd',
            'tsserver',
            'lua-language-server',
            'vimls',
            'bashls',
            'yamlls',
            'pyright',
            'autopep8',
            'bash-language-server',
            'xmlformatter',
        }
    }
end

function M.autopairs()
    local npairs = require 'nvim-autopairs'
    npairs.setup {
        check_ts = true,
    }
end

function M.gitsigns()
    local gitsigns = require 'gitsigns'
    gitsigns.setup {
        current_line_blame = true,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol',
            delay = 100,
            ignore_whitespace = false,
        },
    }
end

function M.zen_mode()
    local truezen = require 'true-zen'
    truezen.setup {

    }
end

return M
