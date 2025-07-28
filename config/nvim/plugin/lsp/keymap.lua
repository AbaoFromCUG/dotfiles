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
            map("<space>f", require("utils.format"), "format")
        end

        if client:supports_method("textDocument/documentColor", buf) and vim.lsp.document_color then
            vim.lsp.document_color.enable(true, buf, {
                style = "virtual"
            })
        end
        if client:supports_method("textDocument/inlayHint", buf) then
            vim.lsp.inlay_hint.enable(true, {
                bufnr = buf
            })
        end
    end,
})
