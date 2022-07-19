return function()
    local builtin = require "telescope.builtin"

    local find_file = function(node)
        builtin.find_files {
            search_dirs = { node.absolute_path },
        }
    end
    local find_word = function(node)
        builtin.live_grep {
            search_dirs = { node.absolute_path },
        }
    end

    local mappings = {
        { key = "?", action = "toggle_help" },
        { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
        { key = "y", action = "copy_path" },
        { key = "Y", action = "copy_name" },

        { key = "a", action = "create" },
        { key = "d", action = "trash" },
        { key = "r", action = "rename" },
        { key = "x", action = "cut" },
        { key = "p", action = "paste" },
        { key = "ff", action = "find file", action_cb = find_file },
        { key = "fw", action = "find string", action_cb = find_word },
    }

    require("nvim-tree").setup {
        disable_netrw = true,
        hijack_netrw = true,
        open_on_setup = false,
        ignore_ft_on_setup = {},
        open_on_tab = true,
        hijack_cursor = false,
        update_cwd = false,
        create_in_closed_folder = true,

        respect_buf_cwd = true,
        actions = {
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = {
                    exclude = {
                        filetype = {
                            "notify",
                            "packer",
                            "qf",
                        },
                        buftype = {
                            "terminal",
                        },
                    },
                },
            },
        },
        renderer = {
            highlight_git = true,
            highlight_opened_files = "icon",
            root_folder_modifier = ":~",
            group_empty = true,

            add_trailing = true,
            icons = {
                padding = " ",
                show = {
                    git = true,
                    folder = true,
                    file = true,
                    folder_arrow = false,
                },
                glyphs = {

                    default = "",
                    symlink = "",
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                    folder = {
                        arrow_open = "",
                        arrow_closed = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                },
            },
            special_files = {
                { "README.md", 1 },
            },
            indent_markers = {
                enable = true,
            },
        },
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        diagnostics = {
            enable = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        update_focused_file = {
            enable = false,
            update_cwd = false,
            ignore_list = {},
        },
        system_open = {
            cmd = nil,
            args = {},
        },
        filters = {
            dotfiles = false,
            custom = {},
        },
        filesystem_watchers = {
            enable = true,
            debounce_delay = 1000,
        },
        git = {
            enable = true,
            ignore = true,
            timeout = 500,
        },
        view = {
            width = 30,
            height = 30,
            hide_root_folder = true,
            side = "left",
            mappings = {
                custom_only = true,
                list = mappings,
            },
            number = false,
            relativenumber = false,
            signcolumn = "yes",
        },
        trash = {
            cmd = "trash",
            require_confirm = true,
        },
    }
end
