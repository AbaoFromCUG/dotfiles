return function()
    local bufferline = require "bufferline"
    -- stylua: ignore start
    local blacklist_filetypes = {
        "dashboard"
    }
    -- stylua: ignore end
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
    }
end
