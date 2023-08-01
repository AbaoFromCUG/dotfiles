return function(path)
    local result = {}
    if vim.loop.fs_stat(path) then
        for line in io.lines(path) do
            line = vim.trim(line)
            local kv = vim.split(line, "=")
            result[kv[1]] = kv[2]
        end
    end
    return result
end
