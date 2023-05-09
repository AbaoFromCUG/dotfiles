return function()
    local tasks = require 'tasks'
    local nvim_tree = require 'nvim-tree'

    nvim_tree.setup {
        disable_netrw = true,
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        actions = {
            open_file = {
                resize_window = true,
            },
        },
        renderer = {
            highlight_opened_files = 'icon',
            group_empty = true,
            add_trailing = true,
            icons = {
                show = {
                    folder_arrow = false,
                },
            },
            special_files = {
                { 'README.md', 'README', 'CMakeLists.txt', 'Makefile', 'package.json' },
            },
            indent_markers = {
                enable = true,
            },
        },
        diagnostics = {
            enable = true,
        },
        update_focused_file = {
            enable = true,
        },
        view = {
            centralize_selection = true,
            adaptive_size = true,
        },
        trash = {
            cmd = 'trash',
        },
        on_attach = require 'keymap.filetreebuf',
    }

    local function restore_nvim_tree()
        nvim_tree.change_dir(vim.fn.getcwd())
        vim.cmd 'NvimTreeRefresh'
    end

    tasks:register_prerestore_task('restore_nvim_tree', restore_nvim_tree)
end
