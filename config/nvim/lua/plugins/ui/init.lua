local conf = require 'plugins.ui.conf'

local M = {}

function M.load_plugins(use)
    use { 'glepnir/zephyr-nvim', config = conf.theme }
    use { 'ellisonleao/gruvbox.nvim' }
    -- color text colorizer, e.g. #5F9EA0 Aqua #91f
    use { 'NvChad/nvim-colorizer.lua', config = conf.colorizer }
    use { 'akinsho/bufferline.nvim', config = require 'plugins.ui.bufferline' }
    -- status line
    use { 'hoob3rt/lualine.nvim', config = require 'plugins.ui.lualine' }
    use { 'arkav/lualine-lsp-progress' }
    use { 'SmiteshP/nvim-navic', config = conf.code_navigation }
    use { 'lukas-reineke/indent-blankline.nvim', config = require 'plugins.ui.indent_blankline' }
    use { 'petertriho/nvim-scrollbar', config = conf.scrollbar }
    use { 'rcarriga/nvim-notify', config = conf.notify }
    use { 'stevearc/dressing.nvim', config = conf.dressing }

    use { 'kyazdani42/nvim-tree.lua', config = require 'plugins.ui.filetree' }
    use { 'simrat39/symbols-outline.nvim', config = conf.symbols_outline }
    use { 'glepnir/dashboard-nvim', config = require 'plugins.ui.dashboard' }
end

return M
