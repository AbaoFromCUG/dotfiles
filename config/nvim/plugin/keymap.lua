require 'keymap.global'

local lang_files = vim.split(vim.fn.globpath(vim.fn.stdpath 'config' .. '/lua/keymap/lang_spec', '*.lua'), '\n')

local lang_map = {}
for _, file in ipairs(lang_files) do
    local ft = vim.fn.fnamemodify(file, ':t:r')
    local handle = require('keymap.lang_spec.' .. ft)
    lang_map[ft] = handle
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { '*' },
    callback = function()
        -- local buf = vim.fn.expand("<abuf>")
        local ft = vim.fn.expand '<amatch>'
        local handle = lang_map[ft]
        if handle then
            handle(0)
        end
    end
})
