local function executable(exe_list)
    for _, exe in ipairs(exe_list) do
        if vim.fn.executable(exe) == 1 then
            return exe
        end
    end
end

local cmd = {
    executable({
        "qmlls",
        "qmlls6",
    }),
}

return {
    cmd = cmd,
    filetypes = { "qml", "qmljs" },
    root_markers = { ".git", "CMakeLists.txt" },
}
