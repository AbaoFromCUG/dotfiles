---@type vim.lsp.Config
return {
    capabilities = {
        textDocument = {
            colorProvider = {
                dynamicRegistration = true,
            },
        },
    },
}
