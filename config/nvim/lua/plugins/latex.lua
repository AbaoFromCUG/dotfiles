---@type LazySpec[]
return {
    {
        "lervag/vimtex",
        ft = { "tex", "latex" },
        init = function()
            vim.g.vimtex_syntax_enabled = 0
            vim.g.vimtex_syntax_conceal_disable = 1
            vim.g.vimtex_view_method = "zathura"
        end,
    },
}
