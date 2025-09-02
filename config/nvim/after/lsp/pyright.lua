local cmd = { vim.fn.executable("delance-langserver") == 1 and "delance-langserver" or "pyright-langserver", "--stdio" }

local pythonPath = vim.fn.exepath("python")

if vim.fn.executable("uv") == 1 and vim.system({ "uv", "tree" }):wait().code == 0 then
    pythonPath = vim.trim(vim.system({ "uv", "run", "which", "python" }):wait().stdout)
elseif vim.fn.executable("pyenv") == 1 then
    pythonPath = vim.trim(vim.system({ "pyenv", "which", "python" }):wait().stdout)
end

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
                supportDocstringTemplate = true
            }
        },
    },
}
