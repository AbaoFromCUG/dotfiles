return function()
    local tree = require("nvim-tree")
    local api = require("nvim-tree.api")
    local function get_available_path()
        local node = api.tree.get_node_under_cursor()
        assert(node, "current cursor node is nil")
        if node.fs_stat.type ~= "directory" then
            node = node.parent
        end
        return node.absolute_path
    end

    local function find_file()
        Snacks.picker.files({
            dirs = {
                get_available_path(),
            },
        })
    end
    local function find_word()
        Snacks.picker.grep({
            dirs = {
                get_available_path(),
            },
        })
    end
    local function context_menu()
        vim.cmd.exec('"normal! \\<RightMouse>"')
        local node = api.tree.get_node_under_cursor

        local items = {
            {
                name = "  New file/folder",
                cmd = function() api.fs.create(node()) end,
                rtxt = "a",
            },

            { name = "separator" },

            {
                name = "  Open in window",
                cmd = function() api.node.open.edit(node()) end,
                rtxt = "o",
            },

            {
                name = "  Open in vertical split",
                cmd = function() api.node.open.vertical(node()) end,
                rtxt = "v",
            },

            {
                name = "  Open in horizontal split",
                cmd = function() api.node.open.horizontal(node()) end,
                rtxt = "s",
            },

            {
                name = "󰓪  Open in new tab",
                cmd = function() api.node.open.tab(node()) end,
                rtxt = "O",
            },

            { name = "separator" },

            {
                name = "  Cut",
                cmd = function() api.fs.cut(node()) end,
                rtxt = "x",
            },

            {
                name = "  Paste",
                cmd = function() api.fs.paste(node()) end,
                rtxt = "p",
            },

            {
                name = "  Copy",
                cmd = function() api.fs.copy.node(node()) end,
                rtxt = "c",
            },

            {
                name = "󰴠  Copy absolute path",
                cmd = function() api.fs.copy.absolute_path(node()) end,
                rtxt = "gy",
            },

            {
                name = "  Copy relative path",
                cmd = function() api.fs.copy.relative_path(node()) end,
                rtxt = "Y",
            },

            { name = "separator" },

            {
                name = "  Open in terminal",
                hl = "ExBlue",
                cmd = function()
                    local path = node().absolute_path
                    local node_type = vim.uv.fs_stat(path).type
                    local dir = node_type == "directory" and path or vim.fn.fnamemodify(path, ":h")

                    vim.cmd("enew")
                    vim.fn.termopen({ vim.o.shell, "-c", "cd " .. dir .. " ; " .. vim.o.shell })
                end,
            },

            { name = "separator" },

            {
                name = "  Rename",
                cmd = function() api.fs.rename(node()) end,
                rtxt = "r",
            },

            {
                name = "  Trash",
                cmd = function() api.fs.trash(node()) end,
                rtxt = "D",
            },

            {
                name = "  Delete",
                hl = "ExRed",
                cmd = function() api.fs.remove(node()) end,
                rtxt = "d",
            },
        }

        require("menu").open(items, { mouse = true })
    end
    tree.setup({
        sync_root_with_cwd = true,
        renderer = {
            highlight_opened_files = "all",
            group_empty = true,
            special_files = {
                "README.md",
                "README",
                "CMakeLists.txt",
                "Cargo.toml",
                "Makefile",
                "package.json",
            },
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
        on_attach = function(bufnr)
            api.config.mappings.default_on_attach(bufnr)
            require("which-key").add({
                { "<leader>ff", find_file, desc = "find file" },
                { "<leader>fw", find_word, desc = "find word" },
                { "<RightMouse>", context_menu, desc = "find word" },
                buffer = bufnr,
            })
        end,
    })

    local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
    vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
            api.events.subscribe(api.events.Event.NodeRenamed, function(data)
                if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                    data = data
                    Snacks.rename.on_rename_file(data.old_name, data.new_name)
                end
            end)
        end,
    })
end
