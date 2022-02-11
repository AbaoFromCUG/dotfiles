return function()
    print("markdown")
    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<C-m>p", "<Plug>MarkdownPreview<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-m>r", "<Plug>MarkdownPreviewToggle<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-m>q", "<Plug>MarkdownPreviewStop<CR>", opts)
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_filetypes = { "markdown" }
end
