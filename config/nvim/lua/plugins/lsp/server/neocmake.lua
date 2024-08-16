return function(config)
    -- disable clangd builtin snippets
    -- config.capabilities.textDocument.completion.completionItem.snippetSupport = false
    -- config.on_new_config = function(new_config, _)
    --     -- local status, cmake = pcall(require, "cmake-tools")
    --     -- if status then
    --     --     cmake.clangd_on_new_config(new_config)
    --     -- end
    -- end
    config.init_options = {
        format = {
            -- enable = true,
        },
        lint = {
            -- enable = true,
        },
        scan_cmake_in_package = true, -- default is true
        semantic_token = true,
    }
end
