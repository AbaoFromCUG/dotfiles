local M = {}



------ Returns the shortest suffixes for a list of paths.
---@param paths string[]
function M.shortest_suffixes(paths)
    local suffix_map = {}
    local path2suffixes = {}
    for _, path in ipairs(paths) do
        local suffixes = vim.iter(vim.fs.parents(path)):map(function(p)
            if p == "/" or p == "." then
                return path
            end
            return path:sub(#p + 2)
        end):totable()

        for _, suffix in ipairs(suffixes) do
            suffix_map[suffix] = (suffix_map[suffix] or 0) + 1
        end
        path2suffixes[path] = suffixes
    end
    -- vim.print(vim.inspect(paths))
    --

    local path2suffix = {}
    for _, path in ipairs(paths) do
        for _, suffix in ipairs(path2suffixes[path]) do
            if suffix_map[suffix] == 1 then
                path2suffix[path] = suffix
                break;
            end
        end
    end

    return path2suffix
end

return M
