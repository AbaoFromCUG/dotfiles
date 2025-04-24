return {
    cmd = { "helm_ls", "serve" },
    filetypes = { "helm" },
    root_markers = { "Chart.yaml" },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },

    settings = {
        ["helm-ls"] = {
            yamlls = {
                enabled = true,
                path = "yaml-language-server",
            },
        },
    },
}
