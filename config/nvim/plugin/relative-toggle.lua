local group = vim.api.nvim_create_augroup("relative-toggle", { clear = true })

local function should_toggle_relative_number(win)
    return vim.api.nvim_win_is_valid(win) and vim.wo[win].number
end

local function get_current_win()
    local ok, win = pcall(vim.api.nvim_get_current_win)
    if not ok then
        return nil
    end

    return win
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    group = group,
    callback = function()
        local win = get_current_win()
        if win and should_toggle_relative_number(win) then
            vim.wo[win].relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    group = group,
    callback = function()
        local win = get_current_win()
        if win and should_toggle_relative_number(win) then
            vim.wo[win].relativenumber = false
        end
    end,
})
