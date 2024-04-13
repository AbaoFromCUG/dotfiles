local function theme()
    -- theme
    if not vim.g.vscode then
        vim.cmd([[colorscheme nightfox]])
    end
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
        "NvimTree",
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

local function symbols_outline()
    require("symbols-outline").setup({
        auto_preview = true,
    })
end

local function dressing()
    require("dressing").setup({
        select = {
            enabled = true,
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

local function noice()
    require("noice").setup({
        messages = {
            enabled = false,
            -- view = "popup",
            -- view_error = false,
            -- view_warn = nil,
            view_history = "messages",
        },
        lsp = {
            signature = {
                enabled = false,
            },
            hover = {
                enabled = false,
            },
        },
        presets = {
            bottom_search = true,
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "Type number" },
                    },
                },
                view = "popup",
            },
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                        { find = "%d fewer lines" },
                        { find = "%d more lines" },
                    },
                },
                opts = { skip = true },
            },
        },
    })
end

return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = theme,
    },
    -- color text colorizer, e.g. #5F9EA0 Aqua #91f
    { "NvChad/nvim-colorizer.lua", config = true },
    { "akinsho/bufferline.nvim", config = require("plugins.ui.bufferline") },
    -- status line
    { "hoob3rt/lualine.nvim", config = require("plugins.ui.lualine") },
    { "SmiteshP/nvim-navic", opts = {
        lsp = {
            auto_attach = true,
        },
    } },
    { "lukas-reineke/indent-blankline.nvim", config = blankline },
    -- components
    { "rcarriga/nvim-notify", config = notify },
    -- lsp progress
    -- { "j-hui/fidget.nvim", tag = "legacy", config = true },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = noice,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },

    { "cpea2506/relative-toggle.nvim" },
    -- status column
    { "luukvbaal/statuscol.nvim", config = statuscol },

    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = require("plugins.ui.filetree"),
    },
    { "simrat39/symbols-outline.nvim", config = symbols_outline },
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        config = require("plugins.ui.dashboard"),
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- terminal
    { "akinsho/toggleterm.nvim", opts = {} },
}
