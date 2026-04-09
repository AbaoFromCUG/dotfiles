local cmd = require("lib.python").get_pyright_cmd()
local pythonPath = require("lib.python").get_python_path()

return {
    cmd = cmd,
    filetypes = { "python" },
    ---@type lspconfig.settings.pyright
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
