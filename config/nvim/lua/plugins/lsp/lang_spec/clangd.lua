return function(config)
    local ProjectConfig = require 'cmake.project_config'
    local project = ProjectConfig.new()

    -- disable clangd builtin snippets
    config.capabilities.textDocument.completion.completionItem.snippetSupport = false
    config.cmd = {
        'clangd',
        '--clang-tidy',
        '--compile-commands-dir=' .. project:get_build_dir():absolute(),
    }
end
