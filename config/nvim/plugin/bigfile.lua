-- 0.2 MB
vim.g.bigfile_size = 1024 * 1024 * 0.2

-- big file optimize
vim.filetype.add({
    pattern = {
        [".*"] = {
            function(path, buf)
                return vim.bo[buf] and vim.bo[buf].filetype ~= "bigfile" and path and vim.fn.getfsize(path) > vim.g.bigfile_size and "bigfile" or nil
            end,
        },
    },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
    pattern = "bigfile",
    callback = function(ev)
        vim.schedule(function()
            vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
        end)
    end,
})
