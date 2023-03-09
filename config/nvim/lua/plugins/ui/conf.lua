local M = {}
function M.theme()
    -- theme
    vim.cmd [[colorscheme nightfox]]
    -- vim.cmd [[colorscheme catppuccin]]
end

function M.code_navigation()
    require 'nvim-navic'.setup {
        highlight = true,
        depth_limit = 3
    }
    vim.g.navic_silence = true
end

function M.symbols_outline()
    require 'symbols-outline'.setup {
        auto_preview = true
    }
end

return M
