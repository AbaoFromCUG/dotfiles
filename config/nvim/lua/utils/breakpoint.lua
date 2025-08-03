local M = {}

--- Store all breakpoints in a global variable to be persisted in the session
M.store_breakpoints = function()
    if not package.loaded["dap"] then
        -- return [[lua vim.print("don't exists")]]
        return ""
    end
    local bps = {}
    local breakpoints = require("dap.breakpoints")
    for buffer_id, buffer_breakpoints in pairs(breakpoints.get()) do
        local filename = vim.api.nvim_buf_get_name(buffer_id)
        bps[filename] = buffer_breakpoints
    end
    if vim.tbl_isempty(bps) then
        return ""
    end
    return string.format("lua require('utils.breakpoint').load_breakpoints(%s)", vim.inspect(vim.json.encode(bps)))
end

--- Load existing breakpoints for all open buffers in the session
M.load_breakpoints = function(data)
    local bps = vim.json.decode(data)
    if vim.tbl_isempty(bps) then
        return
    end
    local breakpoints = require("dap.breakpoints")
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local filename = vim.api.nvim_buf_get_name(buf)
        local buffer_breakpoints = bps[filename]
        if buffer_breakpoints ~= nil then
            for _, bp in pairs(buffer_breakpoints) do
                local line = bp.line
                local opts = {
                    condition = bp.condition,
                    log_message = bp.logMessage,
                    hit_condition = bp.hitCondition,
                }
                breakpoints.set(opts, buf, line)
            end
        end
    end
end

return M
