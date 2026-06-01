local Path = require("pathlib")

local function get_vue_plugin_path()
    local command = vim.fn.exepath("vue-language-server")


    local realpath = vim.uv.fs_realpath(command) or command
    local path = Path.new(realpath)
    local candidates = {
        path:parent():parent(),
        path:parent():parent() / "@vue/language-server",
        path:parent() / "node_modules/@vue/language-server",
    }

    for _, candidate in ipairs(candidates) do
        if candidate:is_dir() then
            return tostring(candidate)
        end
    end
end

local vue_plugin_path = get_vue_plugin_path()


return {
    cmd = { "vtsls", "--stdio" },

    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },

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
