local Path = require("pathlib")
local vls_path = Path.new(require("mason-registry").get_package("vue-language-server"):get_install_path())
local vue_plugin_path = tostring(vls_path / "node_modules/@vue/language-server")

return {
    cmd = { "vtsls", "--stdio" },

    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    {
                        name = "@vue/typescript-plugin",
                        location = vue_plugin_path,
                        languages = { "vue" },
                        configNamespace = "typescript",
                        enableForWorkspaceTypeScriptVersions = true,
                    },
                },
            },
        },
    },
}
