local conf = require 'plugins.misc.conf'

return {
    { 'Shatur/neovim-cmake',    config = require 'plugins.misc.cmake' },
    --[[
    --      Language specific
    --]]
    {
        'ellisonleao/glow.nvim',
        ft = 'markdown',
        opts = { style = 'dark', width = 120, }
    },
    { 'AckslD/nvim-FeMaco.lua', config = true,                         ft = 'markdown' },
    { 'nvim-neorg/neorg',       config = require 'plugins.misc.neorg', ft = 'norg' },
    { 'lervag/vimtex',          config = conf.tex,                     ft = 'tex' },
}
