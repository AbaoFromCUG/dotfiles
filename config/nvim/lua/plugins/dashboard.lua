return function()
    local db = require 'dashboard'
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local fn = vim.fn
    local install_path = fn.stdpath 'data' .. '/site/pack/*/*/'
    local plugin_count = #fn.split(fn.globpath(install_path, '*'), '\n')
    vim.g.dashboard_default_executive = 'telescope'

    db.custom_header = {
        '███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
        '████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
        '██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
        '██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
        '██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
        '╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
    }

    -- db.preview_command = "cat |lolcat -F 0.3"
    -- db.preview_file_path = vim.fn.stdpath "config" .. "/logo.cat"
    -- db.preview_file_height = 6
    -- db.preview_file_width = 56

    local function format_desc(name)
        return string.format(' %-50s', name)
    end

    db.custom_center = {
        {
            icon = '📦',
            desc = format_desc 'Restore session',
            action = function()
                vim.api.nvim_command 'Autosession search'
            end,
            shortcut = 'SPC f s',
        },
        {
            icon = '🔭',
            desc = format_desc 'Find File',
            action = function()
                builtin.find_files {}
            end,
            shortcut = 'SPC f f',
        },
        {
            icon = '📖',
            desc = format_desc 'Recently opend files',
            action = function()
                builtin.oldfiles {}
            end,
            shortcut = 'SPC f h',
        },
        {
            icon = '🔠',
            desc = format_desc 'Find words',
            action = function()
                builtin.live_grep {}
            end,
            shortcut = 'SPC f w',
        },
        {
            icon = '📌',
            desc = format_desc 'Find marks',
            action = function()
                builtin.marks {}
            end,
            shortcut = 'SPC f m',
        },
    }

    local version = vim.version()
    db.custom_footer = {
        string.format('🛸 loaded %d plugins', plugin_count),
        string.format('🔖%d.%d.%d', version.major, version.minor, version.patch),
    }

end
