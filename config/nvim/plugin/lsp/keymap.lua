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

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf
        ---@cast client -nil
        local function map(lhs, rhs, desc, mode) vim.keymap.set(mode or "n", lhs, rhs, { desc = desc, buffer = buf }) end
        if client:supports_method("textDocument/definition", buf) then
            map("gd", function() Snacks.picker.lsp_definitions() end, "goto definition")
        end
        map("gd", function() Snacks.picker.lsp_definitions() end, "goto definition")
        if client:supports_method("textDocument/declaration", buf) then
            map("gD", function() Snacks.picker.lsp_declarations() end, "goto declaration")
        end
        -- if client:supports_method("textDocument/diagnostic", buf) then
        map("<space>e", vim.diagnostic.open_float, "open diagnostic")
        -- end
        if client:supports_method("textDocument/formatting", buf) then
            map("<space>f", smart_format, "format")
        end
    end,
})
