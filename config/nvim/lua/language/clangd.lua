return function(config)
    -- disable clangd builtin snippets
    config.capabilities.textDocument.completion.completionItem.snippetSupport = false
end
