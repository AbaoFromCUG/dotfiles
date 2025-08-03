---@type LazySpec[]
return {
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
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "focus right tab" },
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "focus left tab" },
        },
        opts = {
            options = {
                -- mode="tabs",
                -- close_command="BufDel %d",
                separator_style = "slant",
                custom_filter = function(buf_number, buf_numbers)
                    local blacklist_filetypes = {
                        "dashboard",
                        "checkhealth",
                        "qf",
                        "httpResult",
                    }
                    local blacklist_filenames = {
                        "%[dap%-terminal%].*",
                    }
                    local filetype = vim.bo[buf_number].filetype
                    if vim.tbl_contains(blacklist_filetypes, filetype) then
                        return false
                    end
                    -- local name = vim.fn.bufname(buf_number)
                    -- for _, value in ipairs(blacklist_filenames) do
                    --     if string.match(name, value) then
                    --         return false
                    --     end
                    -- end
                    return true
                end,
                custom_areas = {
                    left = function()
                        return vim.tbl_map(
                            function(item) return { text = item } end,
                            require("edgy-group.stl").get_statusline("left")
                        )
                    end,
                },
            },
        }
    },
    -- winbar
    {
        "b0o/incline.nvim",
        config = function() require("incline").setup() end,
        -- Optional: Lazy load Incline
        event = "VeryLazy",
    },
    -- status line
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",

        opts_extend = { "sections.lualine_a", "sections.lualine_b", "sections.lualine_c", "sections.lualine_d", "sections.lualine_x", "sections.lualine_y", "sections.lualine_z" },
        opts = {
            options = {
                icons_enabled = true,
                icon_only = true,
                section_separators = "",
                component_separators = "",
            },
            sections = {
                lualine_a = {
                    "mode",
                },
                lualine_b = {
                    -- "filename",
                    {
                        function()
                            local bar = require("lspsaga.symbol.winbar").get_bar()
                            if bar then
                                return bar
                            end
                            return ""
                        end,
                        cond = function() return not not package.loaded["lspsaga"] end,
                    },
                },
                lualine_c = {
                    "%=",
                    {
                        function()
                            local stl = require("edgy-group.stl")
                            local bottom_line = stl.get_statusline("bottom")
                            return table.concat(bottom_line)
                        end,
                    },
                },
                lualine_x = { "diff", "diagnostics" },
                lualine_y = { "encoding", "fileformat", "filetype" },
                lualine_z = { "progress", "location" },
            },
            extensions = {},
        },
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
        lazy = false,
        priority = 1001,
        enabled = false,
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
        dependencies = "edgy.nvim",
        event = "VeryLazy",
        opts = {
            groups = {
                left = {
                    {
                        icon = "",
                        titles = { "Neo-Tree", "Neo-Tree Buffers" },
                        pick_key = "f"
                    },
                    {
                        icon = "",
                        titles = { "Scope", "Breakpoints", "Stacks", "Watches" },
                        pick_key = "d"
                    },
                    {
                        icon = "",
                        titles = { "dapui_scopes", "dapui_watches" },
                        pick_key = "d",
                    },
                },
                right = {
                    {
                        icon = "󰋖",
                        titles = { "Help" },
                    },
                    {
                        icon = "",
                        titles = { "Database" },

                    }
                },
                bottom = {
                    {
                        icon = "",
                        titles = { "Terminal" },
                    },
                    {
                        icon = "",
                        titles = { "Console", "Repl" },
                    }
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
                        pcall(edgy_group.open_group_index, group.position, group.index, toggle)
                    end
                end,
            },
        }
    },
    {
        "folke/edgy.nvim",
        opts = {
            top = {},

            ---@type Edgy.View.Opts[]
            left = {
                {
                    title = "Neo-Tree",
                    ft = "neo-tree",
                    filter = function(buf)
                        return vim.b[buf].neo_tree_source == "filesystem"
                    end,
                    open = "Neotree filesystem reveal toggle",
                },
                {
                    title = "Neo-Tree Buffers",
                    ft = "neo-tree",
                    filter = function(buf)
                        return vim.b[buf].neo_tree_source == "buffers"
                    end,
                    open = "Neotree position=top buffers",
                },
                {
                    title = "Scope",
                    ft = "dapui_scopes",
                },
                {
                    title = "Breakpoints",
                    ft = "dapui_breakpoints",
                },
                {
                    title = "Stacks",
                    ft = "dapui_stacks",
                },
                {
                    title = "Watches",
                    ft = "dapui_watches",
                },

            },
            right = {
                {
                    title = "Help",
                    ft = "help",
                    size = { width = 0.6 },
                    -- only show help buffers
                    filter = function(buf) return vim.bo[buf].buftype == "help" end,
                },
                {
                    title = "Outline",
                    ft = "Outline",
                    open = "Outline",
                },
                {
                    title = "Database",
                    ft = "dbui",
                    size = { width = 0.3 },
                    open = "DBUI",
                },
            },
            bottom = {

                {
                    title = "Terminal",
                    ft = "toggleterm",
                    size = { height = 0.4 },
                    -- exclude floating windows
                    filter = function(buf, win) return vim.api.nvim_win_get_config(win).relative == "" end,
                    open = 'exe v:count1 . "ToggleTerm"'
                },
                {
                    title = "Console",
                    ft = "dapui_console",
                },
                {
                    title = "Repl",
                    ft = "dap-repl",
                },
                { ft = "qf",            title = "QuickFix" },
                { ft = "spectre_panel", size = { height = 0.4 } },
                { ft = "httpResult",    size = { height = 0.4 } },
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
        opts = {
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
            update_focused_file = {
                enable = true
            }
        }
    },

    {
        "hedyhli/outline.nvim",

        opts = {},
        keys = {
            { "<leader>vo", "<cmd>Outline<cr>", desc = "Toggle Outline" }
        },
    },
}
