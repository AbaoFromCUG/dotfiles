local conf = require 'plugins.editor.conf'
local M = {}

function M.load_plugins(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'skywind3000/asyncrun.vim'
    use 'tami5/sqlite.lua'
    use 'kyazdani42/nvim-web-devicons'

    use { 'folke/which-key.nvim', config = conf.which_key }
end

return M
