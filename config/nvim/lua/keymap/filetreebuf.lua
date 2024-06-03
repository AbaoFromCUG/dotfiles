local api = require("nvim-tree.api")
local builtin = require("telescope.builtin")
local which_key = require("which-key")

local function get_available_path()
    local node = api.tree.get_node_under_cursor()
    assert(node, "current cursor node is nil")
    if node.fs_stat.type ~= "directory" then
        node = node.parent
    end
    return node.absolute_path
end

local create_template = function()
    -- (get_available_path())
end

local find_file = function()
    builtin.find_files({
        search_dirs = { get_available_path() },
    })
end
local find_word = function()
    builtin.live_grep({
        search_dirs = { get_available_path() },
    })
end

local desc = function(desc)
    return "nvim-tree: " .. desc
end

return function(bufnr)
    api.config.mappings.default_on_attach(bufnr)
    which_key.register({
        ["A"] = { create_template, desc("Create from Template") },
        ["i"] = { create_template, desc("Create from Template") },
        ["<leader>"] = {
            f = {
                name = "find",
                f = { find_file, desc("Find files") },
                w = { find_word, desc("Find word") },
            },
        },
    }, {
        buffer = bufnr,
        silent = false,
    })
end
