return function()
    local tree = require("nvim-tree")
    local tree_api = require("nvim-tree.api")
    local function get_available_path()
        local node = tree_api.tree.get_node_under_cursor()
        assert(node, "current cursor node is nil")
        if node.fs_stat.type ~= "directory" then
            node = node.parent
        end
        return node.absolute_path
    end

    local find_file = function()
        require("telescope.builtin").find_files({
            search_dirs = { get_available_path() },
        })
    end
    local find_word = function()
        require("telescope.builtin").live_grep({
            search_dirs = { get_available_path() },
        })
    end
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
        },
        trash = {
            cmd = "trash",
        },
        on_attach = function(bufnr)
            tree_api.config.mappings.default_on_attach(bufnr)
            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end
            map("n", "<leader>ff", find_file, "find file")
            map("n", "<leader>fw", find_word, "find word")
        end,
    })

end
