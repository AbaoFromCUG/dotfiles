return function(config)
    local Path = require("pathlib")
    -- local mason_path = "mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin/"
    local mason_path = "mason/packages/vue-language-server/node_modules/@vue/language-server"
    local plugin_path = tostring(Path(vim.fn.stdpath("data")) / mason_path)

    local languages = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "vue",
    }
    config.init_options = vim.tbl_deep_extend("force", config.init_options or {}, {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = plugin_path,
                languages = { "javascript", "typescript", "vue" },
            },
        },
    })
    config.filetypes = languages
end
