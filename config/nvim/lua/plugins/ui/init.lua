local function theme()
    -- theme
    if vim.g.vscode then
    else
        vim.cmd([[colorscheme nightfox]])
    end
end

local function code_navigation()
    require("nvim-navic").setup({
        highlight = true,
        depth_limit = 3,
    })
    vim.g.navic_silence = true
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
    { "SmiteshP/nvim-navic", config = code_navigation },
    { "lukas-reineke/indent-blankline.nvim", config = blankline },
    { "rcarriga/nvim-notify", config = notify },
    { "MunifTanjim/nui.nvim" },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = dressing,
    },
    { "cpea2506/relative-toggle.nvim" },
    -- status column
    { "luukvbaal/statuscol.nvim", config = statuscol },
    -- lsp progress
    { "j-hui/fidget.nvim", tag = "legacy", config = true },
    {
        "kyazdani42/nvim-tree.lua",
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
        -- config = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
