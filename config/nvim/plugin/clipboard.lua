if vim.env.TMUX ~= nil and vim.env.SSH_TTY ~= nil then
    local copy = { "tmux", "load-buffer", "-w", "-" }
    local paste = { "bash", "-c", "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -" }
    vim.g.clipboard = {
        name = "tmux",
        copy = {
            ["+"] = copy,
            ["*"] = copy,
        },
        paste = {
            ["+"] = paste,
            ["*"] = paste,
        },
        cache_enabled = 0,
    }
elseif os.getenv("SSH_TTY") ~= nil then
    local function no_paste(reg)
        return function(lines)
            -- Do nothing! We can't paste with OSC52
        end
    end

    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
            -- ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
            -- ['*'] = require('vim.ui.clipboard.osc52').paste('*'),

            ["+"] = no_paste("+"),
            ["*"] = no_paste("*"),
        }
    }
end
