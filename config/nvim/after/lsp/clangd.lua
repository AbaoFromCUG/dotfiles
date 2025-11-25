return {
    cmd = {
        "clangd",
        "--header-insertion-decorators=false",
    },
    settings = {
        clangd = {
            InlayHints = {
                Designators = true,
                Enabled = true,
                ParameterNames = true,
                DeducedTypes = true,
            },
            fallbackFlags = { "-std=c++23" },
        },
    },

    reuse_client = function() return true end,
}
