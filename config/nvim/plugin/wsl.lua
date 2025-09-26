local uname = vim.uv.os_uname()
if not uname.release:find("WSL") then -- WSL
    return
end
vim.system({ "/mnt/c/Windows/system32/cmd.exe", "/c", "echo", "%path%" }, { text = true }, function(obj)
    if obj.code ~= 0 then
        vim.print(obj.stderr)
        return
    end
    local paths = string.gsub(obj.stdout, "C:", "/mnt/c")
    paths = paths:gsub("\\", "/")
    paths = vim.iter(vim.split(paths, ";")):filter(function(path)
        -- print(path)
        path = path:lower()
        return not vim.iter({
            "pyenv",
            "nodejs",
            "git",
            "neovim",
            "go",
            "cmake",
            "cargo",
        }):any(function(name)
            return path:find(name)
        end)
    end):join(":")
    vim.schedule(function() vim.env.PATH = vim.env.PATH .. ":" .. paths end)
end)
