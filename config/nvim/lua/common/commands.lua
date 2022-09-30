local M = {}


local command_map = {}

---register command, support ${id:handle_args}
---@param id string
---@param func function
---@param opts table
function M.register_command(id, func, opts)
    if command_map[id] ~= nil then
        vim.notify(string.format('exist command named `%s`', id))
        return
    end
    command_map[id] = {
        func = func,
        opts
    }
end

---get command by id
---@param id string
function M.get_command(id)
    local handler = command_map[id]
    if handler ~= nil then
        return handler.func
    end
    -- vim.notify("there isn't command ", id)
    return handler
end

return M
