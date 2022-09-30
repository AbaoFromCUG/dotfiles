local conf = require 'plugins.misc.conf'

local M = {}

function M.load_plugins(use)
    use { 'Shatur/neovim-cmake', config = require 'plugins.misc.cmake' }
    --[[
    --      Language specific
    --]]
    use { 'ellisonleao/glow.nvim', ft = 'markdown', config = conf.glow }
    use { 'AckslD/nvim-FeMaco.lua', ft = 'markdown', config = conf.femaco }
    use { 'nvim-neorg/neorg', ft = 'norg', config = require 'plugins.misc.neorg' }
end

return M
