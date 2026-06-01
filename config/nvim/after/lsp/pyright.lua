local cmd = require('utils.python').get_pyright_cmd()
local pythonPath = require('utils.python').get_python_path()

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
