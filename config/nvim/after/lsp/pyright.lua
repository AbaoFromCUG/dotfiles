local cmd = { vim.fn.executable("delance-langserver") == 1 and "delance-langserver" or "pyright-langserver", "--stdio" }

local pythonPath = require("lib.python").get_python_path()

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
