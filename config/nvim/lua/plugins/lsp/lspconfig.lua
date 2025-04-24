return function()
    require("vim.lsp.log").set_format_func(vim.inspect)

    -- vim.lsp.config("*", {
    --     -- capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
    -- })


    require("mason-lspconfig").setup_handlers {
        function(server_name)
            vim.lsp.enable(server_name)
        end,
    }

    vim.iter({
        "qmlls",
    }):each(function(server_name) vim.lsp.enable(server_name) end)
end
