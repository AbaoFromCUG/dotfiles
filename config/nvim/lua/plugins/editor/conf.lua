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
            'sumneko_lua',
            'vimls',
            'bashls',
            'yamlls',
            'pyright',
            'jsonls',
        }
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

function M.fidget()
    require 'fidget'.setup {}
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

function M.hop()
    local hop = require 'hop'
    hop.setup { keys = 'etovxqpdygfblzhckisuran' }
end

return M
