return function()
    local lspconfig = require("lspconfig")
    require("vim.lsp.log").set_format_func(vim.inspect)

    local Path = require("pathlib")
    local vls_path = Path.new(require("mason-registry").get_package("vue-language-server"):get_install_path())
    local vue_plugin_path = tostring(vls_path / "node_modules/@vue/language-server")

    ---@diagnostic disable: missing-fields
    ---@type lspconfig.options
    local configs = {
        vtsls = {
            filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
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
        },
        clangd = {
            cmd={
                "clangd",
                "--header-insertion-decorators=false"

            },
            settings = {
                clangd = {
                    InlayHints = {
                        Designators = true,
                        Enabled = true,
                        ParameterNames = true,
                        DeducedTypes = true,
                    },
                    fallbackFlags = { "-std=c++20" },
                },
            },
        },
        pyright = {
            cmd = vim.fn.executable("delance-langserver") and { "delance-langserver", "--stdio" } or nil,
            settings = {
                python = {
                    pythonPath = vim.trim(vim.system({ "pyenv", "which", "python" }):wait().stdout),
                },
            },
        },
        jsonls = {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        },
        yamlls = {
            settings = {
                yaml = {
                    format = {
                        enable = true,
                    },
                },
            },
        },
        qmlls = {
            cmd = { "qmlls6" },
        },
        tinymist = {
            -- offset_encoding = "utf-8",
            root_dir = function() return vim.fn.getcwd() end,
            settings = {
                semantic_tokens = "disable",
            },
        },
    }
    ---@diagnostic enable: missing-fields

    local function setup_server(server_name)
        local server = lspconfig[server_name]
        local config = vim.tbl_deep_extend("keep", configs[server_name] or {}, {
            capabilities = vim.lsp.protocol.make_client_capabilities(),
        })
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        config.capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
        -- vim.print(config.capabilities)
        server.setup(config)
    end

    require("mason-lspconfig").setup_handlers({
        setup_server,
        ["lua_ls"] = function() end,
    })

    setup_server("qmlls")
    setup_server("neocmake")
end
