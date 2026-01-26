local schemas = require("schemastore").json.schemas()

return {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { ".git" },

    settings = {
        json = {
            schemas = schemas,
            validate = { enable = true },
        },
    },
}
