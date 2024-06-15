---@class Dotfiles.KeymapSpec: vim.keymap.set.Opts
---@field [1] string|string[] mode
---@field [2] string lhs
---@field [3] string|fun() rhs

---@param spec Dotfiles.KeymapSpec
local function map(spec)
    local mode = spec[1]
    local lhs = spec[2]
    local rhs = spec[3]
    spec[1], spec[2], spec[3] = nil, nil, nil
    vim.keymap.set(mode, lhs, rhs, spec)
end

return map
