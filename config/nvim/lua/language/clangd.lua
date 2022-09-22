return function(config)
    -- disable clangd builtin snippets
    config.capabilities.textDocument.completion.completionItem.snippetSupport = false

    local ProjectConfig = require('cmake.project_config')
    local project = ProjectConfig.new()

    config.cmd = {
        'clangd',
        '--clang-tidy',
        '--compile-commands-dir=' .. project:get_build_dir():absolute(),
    }

end
