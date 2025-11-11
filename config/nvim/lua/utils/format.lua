local function smart_format()
    -- exclude format client
    local client_names = { "eslint", "lua_ls" }
    for _, client_name in ipairs(client_names) do
        local client = vim.lsp.get_clients({ name = client_name })[1]
        if client then
            vim.lsp.buf.format({
                filter = function(c) return c.name == client_name end,
            })
            return
        end
    end
    vim.lsp.buf.format()
end
return smart_format
