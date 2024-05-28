local function theme()
    -- theme
    if not vim.g.vscode then
        vim.cmd([[colorscheme nightfox]])
    end
end
local function lualine()
    local code_navigation = require("nvim-navic")
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
                    function()
                        return code_navigation.get_location()
                    end,
                    cond = code_navigation.is_available,
                },
            },
            lualine_c = {
                "launcher",
                "overseer",
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

local function notify()
    vim.notify = require("notify")
end

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
        config = notify,
        event = "VeryLazy",
    },
    -- lsp progress
    {
        "j-hui/fidget.nvim",
        config = true,
        event = "VeryLazy",
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

    ---@type LazySpec
    {
        "mikavilpas/yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = "VeryLazy",
        ---@type YaziConfig
        opts = {
            open_for_directories = false,
        },
    },
    {
        "akinsho/toggleterm.nvim",
        config = true,
        event = "VeryLazy",
    },
    {
        "willothy/flatten.nvim",
        config = true,
        lazy = false,
    },
}
