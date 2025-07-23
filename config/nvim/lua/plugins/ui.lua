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
        "hoob3rt/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local symbol_component = {
                function()
                    local bar = require("lspsaga.symbol.winbar").get_bar()
                    if bar then
                        return bar
                    end
                    return ""
                end,
                cond = function() return not not package.loaded["lspsaga"] end,
            }
            local function is_active()
                local ok, hydra = pcall(require, "hydra.statusline")
                return ok and hydra.is_active()
            end

            local function get_name()
                local ok, hydra = pcall(require, "hydra.statusline")
                if ok then
                    return hydra.get_name()
                end
                return ""
            end
            return {
                options = {
                    icons_enabled = true,
                    icon_only = true,
                    section_separators = "",
                    component_separators = "",
                },
                sections = {
                    lualine_a = {
                        "mode",
                        { get_name, cond = is_active },
                    },
                    lualine_b = {
                        -- "filename",
                        symbol_component,
                        "diff",
                        -- {
                        --     symbols.get,
                        --     cond = symbols.has,
                        -- },
                    },
                    lualine_c = {
                        -- "launcher",
                        -- "overseer",
                    },
                    lualine_x = { "diagnostics" },
                    lualine_y = { "encoding", "fileformat", "filetype" },
                    lualine_z = { "progress", "location" },
                },
                extensions = {},
            }
        end,
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
        version = "v0.5.1",
        priority = 1001,
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
        "folke/edgy.nvim",
        opts = function()
            local opts = {
                top = {},

                ---@type Edgy.View.Opts[]
                left = {
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
                        ft = "dbui",
                        title = "Database",
                        size = { width = 0.3 },
                        open = "DBUI",
                    },

                    {
                        ft = "help",
                        size = { width = 0.6 },
                        -- only show help buffers
                        filter = function(buf) return vim.bo[buf].buftype == "help" end,
                    },
                },
                bottom = {
                    {
                        title = "Console",
                        ft = "dapui_console",
                    },
                    {
                        title = "Repl",
                        ft = "dap-repl",
                    },
                    {
                        ft = "toggleterm",
                        size = { height = 0.4 },
                        -- exclude floating windows
                        filter = function(buf, win) return vim.api.nvim_win_get_config(win).relative == "" end,
                    },
                    { ft = "qf",            title = "QuickFix" },
                    { ft = "spectre_panel", size = { height = 0.4 } },
                    { ft = "httpResult",    size = { height = 0.4 } },
                },
            }
            for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "trouble",
                    filter = function(_buf, win)
                        return vim.w[win].trouble
                            and vim.w[win].trouble.position == pos
                            and vim.w[win].trouble.type == "split"
                            and vim.w[win].trouble.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end
            return opts
        end,
        event = "VeryLazy",
    },
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
    },
    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            { "<leader>b", "<cmd>NvimTreeToggle<cr>", desc = "file explorer" },

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
    }
}
