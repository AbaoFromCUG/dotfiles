---@diagnostic disable: missing-fields
---@type lspconfig.options.lua_ls
return {
    settings = {
        Lua = {
            format = {
                enable = true,
            },
            hint = {
                enable = true,
            },
        },
    },
}
