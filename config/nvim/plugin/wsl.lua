local uname = vim.uv.os_uname()
if not uname.release:find("WSL") then -- WSL
    return
end
vim.system({ "/mnt/c/Windows/system32/cmd.exe", "/c", "echo", "%path%" }, { text = true }, function(obj)
    local paths = string.gsub(obj.stdout, "C:", "/mnt/c")
    paths = paths:gsub("\\", "/")
    -- paths = paths:gsub(";.*pyenv.*;", ";")
    paths = paths:gsub(";", ":")
    vim.schedule(function() vim.env.PATH = vim.env.PATH .. ":" .. paths end)
end)


-- vim.g.clipboard = {
--     name = "WslClipboard",
--     copy = {
--         ["+"] = "clip.exe",
--         ["*"] = "clip.exe",
--     },
--     paste = {
--         ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--         ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     },
--     cache_enabled = 0,
-- }
