local M = {}

function M.get_python_path()
    local pythonPath = vim.fn.exepath("python")
    if vim.fn.executable("uv") == 1 and vim.fn.executable(".venv/bin/python") == 1 then
        pythonPath = vim.fn.exepath(".venv/bin/python")
    elseif vim.fn.executable("pyenv") == 1 then
        local result = vim.system({ "pyenv", "which", "python" }):wait()
        assert(result.code == 0, "Failed to get python path from pyenv")
        assert(result.stdout ~= nil, "No output from pyenv which python:" .. result.stderr)
        pythonPath = vim.trim(result.stdout)
    end
    return pythonPath
end

return M
