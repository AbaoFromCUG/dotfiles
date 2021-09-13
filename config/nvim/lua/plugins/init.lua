-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require('packer').startup(function()
  -- base plugin
  use 'wbthomason/packer.nvim'
  use {'nvim-lua/plenary.nvim'} 
  use 'nvim-lua/popup.nvim'

  -- theme & color
  use { 'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end }
  -- terminal
  use {'akinsho/nvim-toggleterm.lua', config = require('plugins.toggleterm')}
  
  -- fuzzy finder
  use { 'nvim-telescope/telescope.nvim', config=require('plugins.telescope')}
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {'nvim-telescope/telescope-fzf-writer.nvim'}
  use {'nvim-telescope/telescope-hop.nvim'}
  use {'nvim-telescope/telescope-dap.nvim'}
  use {'nvim-telescope/telescope-project.nvim'}

  -- icon
  use 'kyazdani42/nvim-web-devicons'
  -- fileexplor
  -- use { 'kyazdani42/nvim-tree.lua', config=require('plugins.tree') }
  use 'kevinhwang91/rnvimr'
  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config=require('plugins.treesitter') }


  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  -- debug
  use { 'mfussenegger/nvim-dap', config = require('plugins.dap')}
  use {'rcarriga/nvim-dap-ui', config = require('plugins.dapui')}
  use {'theHamsta/nvim-dap-virtual-text'}

  -- cmake
  use "skywind3000/asyncrun.vim"
  use {'Shatur/neovim-cmake'}

  -- project
  use 'ahmedkhalf/project.nvim'

  -- dashboard
  use 'glepnir/dashboard-nvim'

  -- snip
  use 'rafamadriz/friendly-snippets'

  -- lsp
  use {'neovim/nvim-lspconfig'}
  use {'kabouzeid/nvim-lspinstall', config=require("plugins.lspinstall")}
end)
