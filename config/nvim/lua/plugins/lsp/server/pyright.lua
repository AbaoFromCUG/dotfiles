return function(config)
    if vim.fn.executable("delance-langserver") then
        config.cmd = { "delance-langserver", "--stdio" }
    end
    config.settings = {
        python = {
            pythonPath = vim.trim(vim.system({ "pyenv", "which", "python" }):wait().stdout),
        },
    }
end
