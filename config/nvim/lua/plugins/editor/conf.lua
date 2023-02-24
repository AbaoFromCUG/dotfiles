local M = {}


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
