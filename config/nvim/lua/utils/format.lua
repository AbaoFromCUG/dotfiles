local function smart_format()
    local eslint = vim.lsp.get_clients({ name = "eslint" })[1]
    if eslint then
        vim.lsp.buf.format({
            filter = function(client) return not vim.tbl_contains({ "ts_ls", "typescript-tools", "vtsls", "volar", "jsonls" }, client.name) end,
        })
    else
        vim.lsp.buf.format()
    end
end
return smart_format
