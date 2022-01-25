return function()
    -- 0 by default, closes the tree when you open a file
    vim.g.nvim_tree_quit_on_open = 1
    -- 0 by default, this option shows indent markers when folders are open
    vim.g.nvim_tree_indent_markers = 1
    -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
    vim.g.nvim_tree_git_hl = 1 -- 0 by default, will enable folder and file icon highlight for opened files/directories.
    vim.g.nvim_tree_highlight_opened_files = 1
    --This is the default. See :help filename-modifiers for more options
    vim.g.nvim_tree_root_folder_modifier = ":~"
    -- 0 by default, append a trailing slash to folder names
    vim.g.nvim_tree_add_trailing = 1
    -- 0 by default, compact folders that only contain a single folder into one node in the file tree
    vim.g.nvim_tree_group_empty = 1
    -- 0 by default, will disable the window picker.
    vim.g.nvim_tree_disable_window_picker = 1
    -- one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
    vim.g.nvim_tree_icon_padding = " "
    -- defaults to ' ➛ '. used as a separator between symlinks' source and target.
    -- vim.g.nvim_tree_symlink_arrow = " >> "
    -- 0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
    vim.g.nvim_tree_respect_buf_cwd = 1
    -- 1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
    vim.g.nvim_tree_create_in_closed_folder = 0
    --1000 by default, control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
    vim.g.nvim_tree_refresh_wait = 500

    vim.g.nvim_tree_window_picker_exclude = {
        filetype = {
            "notify",
            "packer",
            "qf",
        },
        buftype = {
            "terminal",
        },
    }
    -- Dictionary of buffer option names mapped to a list of option values that
    -- indicates to the window picker that the buffer's window should not be
    -- selectable.
    -- List of filenames that gets highlighted with NvimTreeSpecialFile
    vim.g.nvim_tree_special_files = {}
    vim.g.nvim_tree_special_files["README.md"] = 1
    vim.g.nvim_tree_show_icons = {
        git = 1,
        folders = 1,
        files = 1,
        folder_arrows = 0,
    }

    -- If 0, do not show the icons for one of 'git' 'folder' and 'files'
    -- 1 by default, notice that if 'files' is 1, it will only display
    -- if nvim-web-devicons is installed and on your runtimepath.
    -- if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
    -- but this will not work when you set indent_markers (because of UI conflict)

    -- default will show icon by default if no icon is provided
    -- default shows no icon by default
    vim.g.nvim_tree_icons = {
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
    }

    -- following options are the default
    -- each of these are documented in `:help nvim-tree.OPTION_NAME`
    require("nvim-tree").setup {
        disable_netrw = true,
        hijack_netrw = true,
        open_on_setup = false,
        ignore_ft_on_setup = {},
        auto_close = true,
        open_on_tab = true,
        hijack_cursor = false,
        update_cwd = false,
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
            hide_root_folder = false,
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
end
