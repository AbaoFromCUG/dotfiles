return function()
    local bufferline = require("bufferline")
    local blacklist_filetypes = {
        "dashboard",
        "checkhealth",
        "qf",
        "httpResult",
    }
    local blacklist_filenames = {
        "%[dap%-terminal%].*",
    }

    bufferline.setup({
        options = {
            -- mode="tabs",
            -- close_command="BufDel %d",
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
                    if filetype == value then return false end
                end
                local name = vim.fn.bufname(buf_number)
                for _, value in ipairs(blacklist_filenames) do
                    if string.match(name, value) then return false end
                end
                return true
            end,
        },
    })
end
