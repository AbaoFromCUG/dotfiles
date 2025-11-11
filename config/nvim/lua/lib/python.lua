local M = {}

function M.get_python_path()
    local pythonPath = vim.fn.exepath("python")
    if vim.fn.executable("uv") == 1 and vim.system({ "uv", "tree" }):wait().code == 0 then
        pythonPath = vim.trim(vim.system({ "uv", "run", "which", "python" }):wait().stdout)
    elseif vim.fn.executable("pyenv") == 1 then
        pythonPath = vim.trim(vim.system({ "pyenv", "which", "python" }):wait().stdout)
    end
    return pythonPath
end

return M
