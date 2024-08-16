return function(config)
    config.capabilities.textDocument.completion.completionItem.snippetSupport = false
    config.settings = {
        clangd = {
            InlayHints = {
                Designators = true,
                Enabled = true,
                ParameterNames = true,
                DeducedTypes = true,
            },
            fallbackFlags = { "-std=c++20" },
        },
    }
end
