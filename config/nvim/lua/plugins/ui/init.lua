local function bufferline()
    local blacklist_filetypes = {
        "dashboard",
        "checkhealth",
        "qf",
        "httpResult",
    }
    local blacklist_filenames = {
        "%[dap%-terminal%].*",
    }
    local Offset = require("bufferline.offset")
    if not Offset.edgy then
        local get = Offset.get
        Offset.get = function()
            if package.loaded.edgy then
                local layout = require("edgy.config").layout
                local ret = { left = "", left_size = 0, right = "", right_size = 0 }
                for _, pos in ipairs({ "left", "right" }) do
                    local sb = layout[pos]
                    if sb and #sb.wins > 0 then
                        local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                        ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
                        ret[pos .. "_size"] = sb.bounds.width
                    end
                end
                ret.total_size = ret.left_size + ret.right_size
                if ret.total_size > 0 then
                    return ret
                end
            end
            return get()
        end
        Offset.edgy = true
    end

    require("bufferline").setup({
        options = {
            -- mode="tabs",
            -- close_command="BufDel %d",
            separator_style = "slant",
            custom_filter = function(buf_number, buf_numbers)
                local filetype = vim.bo[buf_number].filetype
                for _, value in ipairs(blacklist_filetypes) do
                    if filetype == value then
                        return false
                    end
                end
                local name = vim.fn.bufname(buf_number)
                for _, value in ipairs(blacklist_filenames) do
                    if string.match(name, value) then
                        return false
                    end
                end
                return true
            end,
        },
    })
end

local function lualine()
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
    require("lualine").setup({
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
    })
end

local function yazi()
    ---@param buf number
    ---@param config YaziConfig
    local function set_keymappings_function(buf, config)
        local helper = require("yazi.keybinding_helpers")
        local function live_grep()
            helper.select_current_file_and_close_yazi(config, {
                on_file_opened = function(chosen_file, _, state)
                    local success, result_or_error = pcall(config.integrations.grep_in_directory, state.last_directory.filename)
                    assert(success, result_or_error)
                end,
            })
        end
        local function find_files()
            helper.select_current_file_and_close_yazi(config, {
                on_file_opened = function(chosen_file, _, state)
                    local directory = state.last_directory.filename
                    require("telescope.builtin").live_grep({
                        search = "",
                        prompt_title = "Grep in " .. directory,
                        cwd = directory,
                    })
                end,
            })
        end
        vim.keymap.set({ "t" }, "<leader>fw", live_grep, { buffer = buf })
        vim.keymap.set({ "t" }, "<leader>ff", find_files, { buffer = buf })
    end
    require("yazi").setup({
        open_for_directories = false,
        set_keymappings_function = set_keymappings_function,
    })
end

---@type LazySpec[]
return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function() vim.cmd([[colorscheme nightfox]]) end,
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
    -- color text colorizer, e.g. #5F9EA0 Aqua #91f #f101ff11
    {
        "norcalli/nvim-colorizer.lua",
        opts = { "qml", "typst", "lua", "vue", "html", "css", user_default_options = { rgb_fn = true, RRGGBBAA = true } },
        event = "VeryLazy",
    },
    {
        "akinsho/bufferline.nvim",
        config = bufferline,
        event = "VeryLazy",
        keys = {
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "focus right tab" },
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "focus left tab" },
        },
    },
    -- status line
    {
        "hoob3rt/lualine.nvim",
        config = lualine,
        event = "VeryLazy",
    },

    { "cpea2506/relative-toggle.nvim", event = "VeryLazy" },

    {
        "nvim-tree/nvim-tree.lua",
        init = function() end,
        config = require("plugins.ui.filetree"),

        keys = {
            { "<leader>b", "<cmd>NvimTreeToggle<cr>", desc = "file manager" },
            { "<leader>vb", "<cmd>NvimTreeToggle<cr>", desc = "file manager" },
        },
    },
    ---@type LazySpec
    {
        "mikavilpas/yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = yazi,
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
        "stevearc/aerial.nvim",
        opts = {},
        cmd = { "AerialToggle", "AerialOpen" },
        keys = {
            { "<leader>vt", "<cmd>AerialToggle right<cr>", desc = "outline" },
        },
    },
    {
        "folke/edgy.nvim",
        opts = {

            ---@type Edgy.View.Opts[]
            left = {
                {
                    title = "NvimTree",
                    ft = "NvimTree",
                    open = "NvimTreeOpen",
                    size = { height = 1 },
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
                    ft = "aerial",
                    pinned = true,
                    -- open = "AerialToggle right",
                },
                {
                    ft = "help",
                    size = { width = 120 },
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
                {
                    ft = "trouble",
                    title = "Trouble",
                    size = { height = 0.4 },
                },
                { ft = "qf", title = "QuickFix" },
                { ft = "spectre_panel", size = { height = 0.4 } },
                { ft = "httpResult", size = { height = 0.4 } },
            },
        },
        event = "VeryLazy",
    },
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
    },
}
