local pythonPath = require("lib.python").get_python_path()
local cmd = require("lib.python").get_pyright_cmd()

---@diagnostic disable: missing-fields
---@type lspconfig.options.pyright
return {
    cmd = cmd,
    filetypes = { "python" },
    settings = {
        python = {
            pythonPath = pythonPath,
            analysis = {
                languageServerMode = "full",
                supportDocstringTemplate = true,
            },
        },
    },
}
