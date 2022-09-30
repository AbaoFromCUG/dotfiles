local M = {}
function M.theme()
    -- theme
    vim.opt.background = 'dark' -- or "light" for light mode
    vim.cmd [[colorscheme zephyr]]
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

function M.scrollbar()
    require 'scrollbar'.setup {}
end

function M.dressing()
    require 'dressing'.setup {
        input = {
            enabled = true,
        },
        select = {
            enabled = true
        }
    }
end

function M.notify()
    vim.notify = require 'notify'
end

function M.symbols_outline()
    require 'symbols-outline'.setup {
        auto_preview = true
    }
end

return M
