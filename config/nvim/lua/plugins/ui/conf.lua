local M = {}
function M.theme()
    -- theme
    vim.cmd [[colorscheme nightfox]]
end

function M.colorizer()
    require 'colorizer'.setup {}
end

function M.code_navigation()
    require 'nvim-navic'.setup {
        highlight = true,
        depth_limit = 3
    }
    vim.g.navic_silence = true
end

function M.noice()
    require 'noice'.setup {
        lsp = {
            signature = {
                enabled = false,
            }
        },
        popupmenu = {
            enabled = false, -- enables the Noice popupmenu UI
        },
    }
end

function M.dressing()
    require 'dressing'.setup {
        input = {
            enabled = false,
        },
        select = {
            enabled = true,
            backend = 'telescope'
        },
    }
end

function M.symbols_outline()
    require 'symbols-outline'.setup {
        auto_preview = true
    }
end

return M
