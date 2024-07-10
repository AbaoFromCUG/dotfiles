local function theme()
    -- theme
    if not vim.g.vscode then
        vim.cmd([[colorscheme nightfox]])
    end
end

local function lualine()
    local trouble = require("trouble")
    local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        hl_group = "lualine_c_normal",
    })
    require("lualine").setup({
        options = {
            icons_enabled = true,
            icon_only = true,
            theme = "gruvbox",
            component_separators = { "", "" },
            section_separators = { "", "" },
            disabled_filetypes = {},
        },
        sections = {
            lualine_a = {
                "mode",
            },
            lualine_b = {
                "filename",
                "diff",
                {
                    symbols.get,
                    cond = symbols.has,
                },
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

local function blankline()
    local filetype_exclude = {
        "startify",
        "dashboard",
        "dotooagenda",
        "log",
        "fugitive",
        "gitcommit",
        "packer",
        "vimwiki",
        "markdown",
        "txt",
        "vista",
        "help",
        "todoist",
        "peekaboo",
        "git",
        "TelescopePrompt",
        "undotree",
        "flutterToolsOutline",
        "", -- for all buffers without a file type
    }
    local indent_blankline = require("ibl")
    indent_blankline.setup({
        scope = {
            show_start = false,
            show_end = false,
        },
        exclude = {
            filetypes = filetype_exclude,
            buftypes = {
                "terminal",
                "nofile",
            },
        },
    })
end

local function statuscol()
    -- consult https://github.com/luukvbaal/statuscol.nvim/issues/27
    -- this will fix fold numbers
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
        relculright = true,
        segments = {
            { text = { "%s" }, click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
            { text = { " ", builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
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
        config = theme,
    },
    -- color text colorizer, e.g. #5F9EA0 Aqua #91f
    {
        "NvChad/nvim-colorizer.lua",
        config = true,
        event = "VeryLazy",
    },
    {
        "akinsho/bufferline.nvim",
        config = require("plugins.ui.bufferline"),
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
    {
        "SmiteshP/nvim-navic",
        opts = {
            lsp = {
                auto_attach = true,
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        config = blankline,
        event = "VeryLazy",
    },
    -- components
    {
        "rcarriga/nvim-notify",
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = function(...)
                require("notify")(...)
            end
        end,
        opts = {
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { focusable = false })
            end,
        },
        -- event = "VeryLazy",
    },
    {

        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            select = {
                enabled = true,
            },
        },
    },

    { "cpea2506/relative-toggle.nvim", event = "VeryLazy" },
    -- status column
    {
        "luukvbaal/statuscol.nvim",
        config = statuscol,
        event = "VeryLazy",
    },

    {
        "nvim-tree/nvim-tree.lua",
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        config = require("plugins.ui.filetree"),

        keys = {
            { "<leader>b", "<cmd>NvimTreeToggle<cr>", desc = "Open the file manager" },
        },
    },
    ---@type LazySpec
    {
        "mikavilpas/yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = yazi,
    },
    {
        "akinsho/toggleterm.nvim",
        config = true,
        event = "VeryLazy",
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
        config = require("plugins.ui.edgy"),
        event = "VeryLazy",
    },
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
    },
}
