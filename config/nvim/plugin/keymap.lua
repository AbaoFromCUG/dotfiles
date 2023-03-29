require 'keymap.global'

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { '*' },
    callback = function()
        local ft = vim.fn.expand '<amatch>'
        local success, handle = pcall(require, 'keymap.lang_spec.' .. ft)
        if success then
            handle(0)
        end
    end
})
