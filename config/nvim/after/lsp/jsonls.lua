local schemas = require("schemastore").json.schemas()

local neoconfSchema = {
    name = "Configuration of `neoconf.nvim`",
    description = "Configuration of `neoconf.nvim`, support lspconfig and more",
    schema = require("neoconf.schema").get():get(),
    fileMatch = {
        vim.fs.joinpath(vim.fn.stdpath("config"), "neoconf.json"),
        ".neoconf.json",
    },

}

schemas = vim.list_extend({ neoconfSchema }, schemas)
-- table.insert(schemas, neoconfSchema)

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
