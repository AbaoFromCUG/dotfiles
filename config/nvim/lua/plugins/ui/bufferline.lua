return function()
    local bufferline = require("bufferline")
    -- stylua: ignore start
    local blacklist_filetypes = {
        'dashboard',
        'checkhealth',
        'qf',
    }
    -- stylua: ignore end
    bufferline.setup({
        options = {
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
    })
end
