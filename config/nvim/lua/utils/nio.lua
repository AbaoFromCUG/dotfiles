local M = {}

---@generic T
---@param fn fun(...): T
---@param opts? { ttl_ms?: integer }
---@return async fun(...): T
function M.singleflight(fn, opts)
    local nio = require("nio")
    opts = opts or {}

    local ttl_ms = opts.ttl_ms

    local future = nil
    local cached = nil
    local expires = 0

    local function now_ms()
        return vim.uv.hrtime() / 1e6
    end

    ---@async
    return function(...)
        local args = { ... }

        -- cache hit
        if ttl_ms and cached and now_ms() < expires then
            return cached
        end

        -- request coalescing
        if future then
            return future:wait()
        end

        local f = nio.control.future()
        future = f

        nio.run(function()
            return fn(unpack(args))
        end, function(ok, result)
            if ok and ttl_ms then
                cached = result
                expires = now_ms() + ttl_ms
            end


            if ok then
                f.set(result)
            else
                f.set_error(result)
            end
            if future == f then
                future = nil
            end
        end)
        return f.wait()
    end
end

return M
