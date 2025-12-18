return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = function()
            return {
                bigfile = {
                    size = 5 * 1024 * 1024,
                },
                indent = {
                    enabled = true,
                    hl = {
                        "SnacksIndent1",
                        "SnacksIndent2",
                        "SnacksIndent3",
                        "SnacksIndent4",
                        "SnacksIndent5",
                        "SnacksIndent6",
                        "SnacksIndent7",
                        "SnacksIndent8",
                    },
                },
                input = {
                    enabled = true,
                },
                picker = {
                    ui_select = true,
                    formatters = {
                        file = {

                            -- filename_only = true,
                            truncate = 60,
                        },
                    },
                },

                notifier = {},
                scroll = { enabled = true },
                statuscolumn = {
                    left = { "sign", "git" },
                    right = { "fold" },
                    -- right = { "mark" },
                    folds = {
                        open = true,
                        git_hl = true,
                    },
                    git = {
                        -- patterns to match Git signs
                        patterns = { "GitSign", "MiniDiffSign" },
                    },
                    refresh = 50, -- refresh at most every 50ms
                },
                styles = {
                    notification = { focusable = false },

                    input = {
                        relative = "cursor",
                        row = -3,
                        col = 0,
                        keys = {
                            i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
                        },
                        b = {
                            completion = true,
                        },
                    },
                },
            }
        end,
        keys = {
            { "<leader>fp", function() Snacks.picker() end,                                         desc = "find find" },
            { "<leader>ff", function() Snacks.picker.files({ ignored = false, hidden = true }) end, desc = "find files" },
            { "<leader>fh", function() Snacks.picker.recent() end,                                  desc = "find history" },
            { "<leader>fw", function() Snacks.picker.grep({ regex = false }) end,                   desc = "find word" },
            -- git
            { "<leader>gB", function() Snacks.gitbrowse() end,                                      desc = "git browse" },
            { "<leader>gl", function() Snacks.lazygit.log() end,                                    desc = "lazygit log" },

            { "<leader>nm", function() Snacks.notifier.hide() end,                                  desc = "dismiss all notifications" },
            { "<leader>nl", function() Snacks.notifier.show_history() end,                          desc = "show all notifications" },

            { ";x",         function() Snacks.bufdelete() end,                                      desc = "close current buffer" },
            { "<leader>vq", function() Snacks.bufdelete() end,                                      desc = "close current buffer" },
            { "<leader>vo", function() Snacks.bufdelete.other() end,                                desc = "close others buffer" },

            { "<leader>zz", function() Snacks.zen.zen() end,                                        mode = { "n", "i", "v" },          desc = "zen mode" },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            event_handlers = {
                {
                    event = "file_renamed",
                    handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end,
                },
                {
                    event = "file_moved",
                    handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end,
                },
            },
            filesystem = {
                window = {
                    mappings = {
                        ["<leader>ff"] = {
                            function(state)
                                ---@type neotree.FileNode
                                local node = state.tree:get_node()

                                local path = vim.fn.fnamemodify(node.path, ":p:h")
                                Snacks.picker.files({ dirs = { path }, title = string.format("Files in (%s)", path) })
                            end,
                            desc = "find files in directory",
                        },

                        ["<leader>fw"] = {
                            function(state)
                                ---@type neotree.FileNode
                                local node = state.tree:get_node()

                                local path = vim.fn.fnamemodify(node.path, ":p:h")
                                Snacks.picker.files({ dirs = { path }, title = string.format("Files in (%s)", path) })
                            end,
                            desc = "find files in directory",
                        },
                    },
                },
            },
        },
    },
}
