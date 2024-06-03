return function(config)
    if vim.fn.executable("delance-langserver") then
        config.cmd = { "delance-langserver", "--stdio" }
    end
end
