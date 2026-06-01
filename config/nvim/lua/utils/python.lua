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

function M.get_pyright_cmd()
    if vim.fn.executable("delance-langserver") == 1 then
        return { "delance-langserver", "--stdio" }
    elseif vim.fn.executable("bun") == 1 then
        return { "bunx", "-p", "@delance/runtime", "delance-langserver" }
    else
        return { "pyright-langserver", "--stdio" }
    end
end

return M
