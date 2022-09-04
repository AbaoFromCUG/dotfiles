return function()
    require("nvim-navic").setup {
        highlight = true,
        depth_limit = 3
    }
    vim.g.navic_silence = true
end
