return function()
    local bufferline = require "bufferline"
    -- stylua: ignore start
    local support_type = {"lua", "vim", "cpp", "c", "java", "javascript", "json", "python", "typescript", "cmake", "xml", "sh", "rust", "yaml", "toml", "org", ""}
    -- stylua: ignore end
    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", opts)
    vim.api.nvim_set_keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader><S-x>", "<cmd>BufferLinePickClose<CR>", opts)
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
            custom_filter = function(buf_number, buf_numbers)
                local filetype = vim.bo[buf_number].filetype
                for _, value in ipairs(support_type) do
                    if filetype == value then
                        return true
                    end
                end
                return false
            end,
        },
    }
end
