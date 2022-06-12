return function()
    local bufferline = require "bufferline"
    -- stylua: ignore start
    local blacklist_filetypes = {
        "dashboard"
    }
    -- stylua: ignore end
    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", opts)
    vim.api.nvim_set_keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-k>o", "", {
        noremap = true,
        callback = function()
            vim.api.nvim_command "BufferLineCloseLeft"
            vim.api.nvim_command "BufferLineCloseRight"
        end,
        desc = "Close other tabs",
    })
    vim.api.nvim_set_keymap("n", "<C-k>i", "<cmd>BufferLineCloseLeft<CR>", {
        noremap = true,
        desc = "Close left tabs"
    })

    vim.api.nvim_set_keymap("n", "<C-k>p", "<cmd>BufferLineCloseRight<CR>", {
        noremap = true,
        desc = "Close right tabs"
    })
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
                for _, value in ipairs(blacklist_filetypes) do
                    if filetype == value then
                        return false
                    end
                end
                return true
            end,
        },
        groups = {
            options = {
                toggle_hidden_on_enter = true,
            },
        },
    }
end
