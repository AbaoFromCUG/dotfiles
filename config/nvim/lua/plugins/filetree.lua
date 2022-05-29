return function()
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
        update_to_buf_dir = {
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
            auto_resize = false,
            mappings = {
                custom_only = false,
                list = {},
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
    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<C-b>", ":NvimTreeToggle<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-k>r", ":NvimTreeRefresh<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-k>f", ":NvimTreeFindFile<CR>", opts)
    vim.api.nvim_command "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"
end
