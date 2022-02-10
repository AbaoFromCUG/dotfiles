return function()
    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<C-m>p", "<Plug>MarkdownPreviewToggle<CR>", opts)
end
