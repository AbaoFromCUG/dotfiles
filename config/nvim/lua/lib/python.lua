local M = {}

function M.get_python_path()
    local pythonPath = vim.fn.exepath("python")
    if vim.fn.executable("uv") == 1 and vim.system({ "uv", "tree" }):wait().code == 0 then
        local result = vim.system({ "uv", "python", "find" }):wait()
        assert(result.code == 0, "Failed to get python path from uv")
        assert(result.stdout ~= nil, "No output from uv which python:" .. result.stderr)
        pythonPath = vim.trim(result.stdout)
    elseif vim.fn.executable("pyenv") == 1 then
        local result = vim.system({ "pyenv", "which", "python" }):wait()
        assert(result.code == 0, "Failed to get python path from pyenv")
        assert(result.stdout ~= nil, "No output from pyenv which python:" .. result.stderr)
        pythonPath = vim.trim(result.stdout)
    end
    return pythonPath
end

return M
