return function()
    local bufferline = require "bufferline"
    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<c-c-i>", ":BufferLineCycleNext<CR>", opts)
    vim.api.nvim_set_keymap("n", "<S-c-c-i>", ":BufferLineCycleNext<CR>", opts)
    bufferline.setup {
        options = {
            close_command = "bdelete! %d",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left",
                },
            },
            separator_style = "slant",
        },
    }
end
