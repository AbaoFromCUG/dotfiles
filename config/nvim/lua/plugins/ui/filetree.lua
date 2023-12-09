return function()
    local tree = require("nvim-tree")
    local tree_api = require("nvim-tree.api")

    tree.setup({
        disable_netrw = true,
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        renderer = {
            highlight_opened_files = "all",
            group_empty = true,
            icons = {
                show = {
                    folder_arrow = false,
                },
            },
            special_files = { "README.md", "README", "CMakeLists.txt", "Cargo.toml", "Makefile", "package.json" },
            indent_markers = {
                enable = true,
            },
        },
        update_focused_file = {
            enable = true,
        },
        view = {
            centralize_selection = true,
            adaptive_size = true,
        },
        trash = {
            cmd = "trash",
        },
        on_attach = require("keymap.filetreebuf"),
    })

    require("session").register_hook("post_restore", "restore_nvim_tree", function()
        tree_api.tree.change_root(vim.fn.getcwd())
        tree_api.tree.reload()
    end)
    require("session").register_hook("pre_save", "close_nvim_tree", function()
        tree_api.tree.close()
    end)
end
