return function()

    local parser_path = vim.fn.stdpath("data") .. "/ts-parsers"

    require("nvim-treesitter").setup({
        install_dir = parser_path,
    })
end
