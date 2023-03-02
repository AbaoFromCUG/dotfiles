local conf = require 'plugins.ui.conf'


return {
    -- { 'catppuccin/nvim',                     config = conf.theme,                           name = 'catppuccin', },
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = conf.theme,
    },
    -- color text colorizer, e.g. #5F9EA0 Aqua #91f
    { 'NvChad/nvim-colorizer.lua',           config = true },
    { 'akinsho/bufferline.nvim',             config = require 'plugins.ui.bufferline' },
    -- status line
    { 'hoob3rt/lualine.nvim',                config = require 'plugins.ui.lualine' },
    { 'SmiteshP/nvim-navic',                 config = conf.code_navigation },
    { 'lukas-reineke/indent-blankline.nvim', config = require 'plugins.ui.indent_blankline' },
    { 'rcarriga/nvim-notify' },
    { 'MunifTanjim/nui.nvim' },
    {
        'stevearc/dressing.nvim',
        event = 'VeryLazy',
        config = conf.dressing
    },
    { 'kyazdani42/nvim-tree.lua',      config = require 'plugins.ui.filetree' },
    { 'simrat39/symbols-outline.nvim', config = conf.symbols_outline },
    {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = require 'plugins.ui.dashboard',
        -- config = true,
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    }
}
