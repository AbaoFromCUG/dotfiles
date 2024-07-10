---@alias DotFiles.Mode "n"|"i"|"c"|"t"|"v"|"o"|"x"

---@class Dotfiles.KeymapSpec: vim.keymap.set.Opts
---@field [1] DotFiles.Mode|DotFiles.Mode[] mode
---@field [2] string lhs
---@field [3] string|fun() rhs
---@field [4]? string desc

---@param specs Dotfiles.KeymapSpec|Dotfiles.KeymapSpec[]
local function map(specs)
    if not vim.islist(specs) then
        specs = { specs }
    end
    ---@cast specs Dotfiles.KeymapSpec[]
    for _, spec in ipairs(specs) do
        local mode = spec[1]
        local lhs = spec[2]
        local rhs = spec[3]

        spec[1], spec[2], spec[3] = nil, nil, nil
        if spec[4] then
            spec.desc = spec[4]
            spec[4] = nil
        end
        vim.keymap.set(mode, lhs, rhs, spec)
    end
end

return map
