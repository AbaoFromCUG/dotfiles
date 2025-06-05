
local cmd = { vim.fn.executable("delance-langserver") == 1 and "delance-langserver" or "pyright-langserver", "--stdio" }
local pythonPath = vim.fn.executable("pyenv") and vim.trim(vim.system({ "pyenv", "which", "python" }):wait().stdout) or nil

return {
    cmd = cmd,
    filetypes = { "python" },
    settings = {
        python = {
            pythonPath = pythonPath,
        },
    },
}
