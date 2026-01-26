local function setup_theme()
    local status, mod = pcall(require, "matugen")
    --TODO: support ssh check
    -- if vim.env.DISPLAY and status and mod then
    --     ---@cast mod.setup -nil
    --     vim.defer_fn(
    --         function()
    --             mod.setup()
    --         end, 100)
    -- else
    vim.cmd([[colorscheme tokyonight]])
    -- end
end


---@type LazySpec[]
return {
    {
        "RRethy/base16-nvim",
        lazy = false,
        priority = 1000,
        config = setup_theme,
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            options = {
                -- transparent = true,
                -- dim_inactive = true,
            },
        },
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            -- transparent = true,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
        end,
    },
    {
        "nvim-zh/colorful-winsep.nvim",
        config = true,
        event = { "WinLeave" },
    },
    {
        "MunifTanjim/nui.nvim",
    },
    {
        "grapp-dev/nui-components.nvim",
    },
    { "nvchad/volt", lazy = true },

    {
        "nvzone/minty",
        cmd = { "Shades", "Huefy" },
    },
    { "nvchad/menu", lazy = true },
    -- color text colorizer, e.g. #5F9EA0 Aqua #91f #f101ff11 oklch(0.147 0.004 49.25)
    {
        "catgoose/nvim-colorizer.lua",
        opts = { filetypes = { "qml", "typst", "lua", "vue", "html", "css", "scss", "tsx" }, user_default_options = { rgb_fn = true, RRGGBBAA = true } },
        event = "VeryLazy",
    },

    { "cpea2506/relative-toggle.nvim", event = "VeryLazy" },

    ---@type LazySpec
    {
        "mikavilpas/yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            open_for_directories = false,
        },
        keys = {
            {
                "<leader>ty",
                "<cmd>Yazi<cr>",
                desc = "yazi:current file",
            },
            {
                -- Open in the current working directory
                "<leader>tw",
                "<cmd>Yazi cwd<cr>",
                desc = "yazi:working directory",
            },
        },
    },
    {
        "mikavilpas/tsugit.nvim",
        keys = {
            { "<leader>gg", function() require("tsugit").toggle() end,          silent = true,                desc = "toggle lazygit" },
            { "<leader>gf", function() require("tsugit").toggle_for_file() end, desc = "lazygit file commits" },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        keys = {
            { ";t", '<cmd>exe v:count1 . "ToggleTerm"<CR>', mode = { "i", "n", "t" } },
        },
        opts = {
            window = {
                open = "smart",
            },
        },
    },
    {
        "willothy/flatten.nvim",
        -- version = "0.5.1",
        lazy = false,
        priority = 1001,
        -- enabled = false,
        opts = {
            integrations = {
                wezterm = true,
                kitty = true,
            },
            window = {
                open = "smart",
            },
        },
    },
    {
        "lucobellic/edgy-group.nvim",
        dependencies = { "folke/edgy.nvim" },
        -- event = "VeryLazy",
        cond = false,
        opts = {
            groups = {
                left = {
                    {
                        icon = " ",
                        titles = { "Scope", "Breakpoints" },
                        pick_key = "d",
                    },
                    {
                        icon = " ",
                        titles = { "Neo-Tree", "Neo-Tree Buffers" },
                        pick_key = "f",
                    },
                },
                right = {
                    {
                        icon = "󰋖",
                        titles = { "Help" },
                    },
                    {
                        icon = "",
                        titles = { "Outline" },
                    },

                    {
                        icon = " ",
                        titles = { "Stacks", "Watches" },
                        pick_key = "d",
                    },

                    {
                        icon = "",
                        titles = { "Database" },
                    },
                },
                bottom = {
                    {
                        icon = "",
                        titles = { "Terminal" },
                        pick_key = "t",
                    },
                    {
                        icon = "",
                        titles = { "Console", "Repl" },
                    },

                    {
                        icon = " ",
                        titles = { "Search" },
                        pick_key = "s",
                    },
                },
            },
            statusline = {
                clickable = true,
                colored = true,
                colors = {
                    active = "Identifier",
                    inactive = "Directory",
                    pick_active = "FlashLabel",
                    pick_inactive = "FlashLabel",
                    separator_active = "StatusLine",
                    separator_inactive = "StatusLine",
                },
                pick_key_pose = "right_separator",
                pick_function = function(key)
                    -- Use upper case to focus all element of the selected group while closing other (disable toggle)
                    local toggle = not key:match("%u")
                    local edgy_group = require("edgy-group")
                    for _, group in ipairs(edgy_group.get_groups_by_key(key:lower())) do
                        local status, message = pcall(edgy_group.open_group_index, group.position, group.index, toggle)
                        assert(status, message)
                    end
                end,
            },
        },
    },
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        cond = false,
        opts = {
            wo = {
                -- winbar = false,
            },
            close_when_all_hidden = false,
            top = {},

            ---@type Edgy.View.Opts[]
            left = {
                {
                    title = "Neo-Tree",
                    ft = "neo-tree",
                    filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
                    open = "Neotree filesystem reveal toggle",
                },
                {
                    title = "Neo-Tree Buffers",
                    ft = "neo-tree",
                    filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
                    open = "Neotree position=top buffers",
                },
                {
                    title = "Scope",
                    ft = "dapui_scopes",
                    size = { height = 0.5, width = 0.2 },
                },
                {
                    title = "Breakpoints",
                    ft = "dapui_breakpoints",
                    size = { height = 0.5, width = 0.2 },
                },
            },
            right = {
                {
                    title = "Help",
                    ft = "help",
                    size = { width = 0.5 },
                    -- only show help buffers
                    filter = function(buf) return vim.bo[buf].buftype == "help" end,
                },
                {
                    title = "Outline",
                    ft = "Outline",
                    open = "Outline",
                    filter = function(buf) return vim.bo[buf].buftype == "nofile" end,
                },
                {
                    title = "Database",
                    ft = "dbui",
                    open = "DBUI",
                },

                {
                    title = "Stacks",
                    ft = "dapui_stacks",
                    size = { height = 0.5, width = 0.2 },
                },
                {
                    title = "Watches",
                    ft = "dapui_watches",
                    size = { height = 0.5, width = 0.2 },
                },
            },
            bottom = {
                {
                    title = "Terminal",
                    ft = "toggleterm",
                    filter = function(buf, win) return vim.api.nvim_win_get_config(win).relative == "" end,
                    open = 'exe v:count1 . "ToggleTerm"',
                },
                {
                    title = "Console",
                    ft = "dapui_console",
                },
                {
                    title = "Repl",
                    ft = "dap-repl",
                },
                { ft = "qf",         title = "QuickFix" },
                {
                    title = "Search",
                    ft = "spectre_panel",
                    open = 'lua require("spectre").toggle()',
                },
                { ft = "httpResult", size = { height = 0.4 } },
            },
        },
    },
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        keys = {
            { "<leader>b",  "<cmd>Neotree filesystem reveal toggle<cr>", desc = "file explorer" },
            { "<leader>vf", "<cmd>Neotree filesystem reveal toggle<cr>", desc = "file explorer" },
        },
        ---@type neotree.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            sort_case_insensitive = false,
            filesystem = {
                window = {
                    mappings = {
                        ["<leader>ty"] = {
                            function(state)
                                ---@type neotree.FileNode
                                local node = state.tree:get_node()
                                local path = vim.fn.fnamemodify(node.path, ":p")
                                require("yazi").yazi({}, path)
                            end,
                            desc = "yazi:current file",
                        },
                        ["/"] = false
                    },
                },

                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
            },
        },
    },
    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            default_file_explorer = true,
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
                natural_order = true,
                is_always_hidden = function(name, _)
                    return name == ".." or name == ".git"
                end,
            },
            win_options = {
                wrap = true,
            }
        },
        lazy = false,
    },
    {
        "hedyhli/outline.nvim",
        opts = {},
        cmd = "Outline",
        keys = {
            { "<leader>vl", "<cmd>Outline<cr>", desc = "Toggle Outline" },
        },
    },
}
