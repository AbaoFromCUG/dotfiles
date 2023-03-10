local lua_files = vim.split(vim.fn.globpath('./', '**/*.lua'), '\n')
print 'start format lua file'
for _, file in ipairs(lua_files) do
    print('format', file, '\n')
    vim.cmd('e ' .. file)
    vim.lsp.buf.format()
    vim.cmd 'silent write'
    vim.cmd 'bd'
end
