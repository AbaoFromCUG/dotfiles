return function()
    local telescope = require "telescope"
    local builtin = require "telescope.builtin"
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/*/*/"
    local plugin_count = #fn.split(fn.globpath(install_path, "*"), "\n")
    vim.g.dashboard_default_executive = "telescope"
    vim.g.dashboard_custom_header = {
        "███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
        "████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
        "██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
        "██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
        "██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
    }
    -- vim.g.dashboard_preview_command = "cat"
    -- vim.g.dashboard_preview_pipeline = "lolcat"
    -- vim.g.dashboard_preview_file = vim.fn.stdpath "config" .. "/logo.cat"
    -- vim.g.dashboard_preview_file_height = 6
    -- vim.g.dashboard_preview_file_width = 56

    vim.g.dashboard_custom_footer = { "🦋neovim loaded " .. plugin_count .. " plugins" }
    local function format_desc(name, shortcut)
        return { string.format("%-50s%10s", name, shortcut) }
    end
    vim.g.dashboard_custom_section = {
        project_list = {
            description = format_desc("📦Open Project", "SPC f p"),
            command = function()
                telescope.extensions.project.project {}
            end,
        },
        session_list = {
            description = format_desc("💻Restore session", "SPC s l"),
            command = function()
                telescope.extensions.sessions.sessions {}
            end,
        },
        find_file = {
            description = format_desc("📄Find File", "SPC f f"),
            command = function()
                builtin.find_files {}
            end,
        },
        find_history = {
            description = format_desc("⏰Recently opend files", "SPC f h"),
            command = function()
                builtin.oldfiles {}
            end,
        },
        find_word = {
            description = format_desc("🔠Find words", "SPC f w"),
            command = function()
                builtin.live_grep {}
            end,
        },
        marks_list = {
            description = format_desc("📌Find marks", "SPC f m"),
            command = function()
                builtin.marks {}
            end,
        },
    }
    local opts = {
        noremap = true,
    }
    local bind = function(key, command)
        vim.api.nvim_set_keymap("n", "<Leader>" .. key, ":" .. command .. "<CR>", opts)
    end
    bind("ss", "SessionSave")
    bind("fs", "Telescope sessions")
    bind("ff", "Telescope find_files")
    bind("fh", "Telescope oldfiles")
    bind("fc", "Telescope colorscheme")
    bind("fw", "Telescope live_grep")
    bind("fm", "Telescope marks")
    bind("nf", "DashboardNewFile")
    bind("fp", "Telescope project")
end
