local config = vim.g.nvim_java_config

if not config then
    return {}
end

local server = require("java-core.ls.servers.jdtls")

local mason_util = require("java-core.utils.mason")

vim.api.nvim_exec_autocmds("User", { pattern = "JavaJdtlsSetup" })

local jdtls_plugins = {}

if config.java_test.enable then
    table.insert(jdtls_plugins, "java-test")
end

if config.java_debug_adapter.enable then
    table.insert(jdtls_plugins, "java-debug-adapter")
end

if config.spring_boot_tools.enable then
    table.insert(jdtls_plugins, "spring-boot-tools")
end

local default_config = server.get_config({
    root_markers = config.root_markers,
    jdtls_plugins = jdtls_plugins,
    use_mason_jdk = config.jdk.auto_install,
})

if config.spring_boot_tools.enable then
    require("spring_boot").setup({
        ls_path = mason_util.get_pkg_path("spring-boot-tools")
            .. "/extension/language-server",
    })

    require("spring_boot").init_lsp_commands()
end

-- vim.print(default_config)
return default_config
