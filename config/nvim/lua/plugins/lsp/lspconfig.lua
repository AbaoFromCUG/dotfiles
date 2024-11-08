local function smart_format()
    local eslint = vim.lsp.get_clients({ name = "eslint" })[1]
    if eslint then
        vim.lsp.buf.format({
            filter = function(client) return client.name ~= "ts_ls" and client.name ~= "typescript-tools" and client.name ~= "vtsls" end,
        })
    else
        vim.lsp.buf.format()
    end
end

return function()
    local lspconfig = require("lspconfig")

    require("vim.lsp.log").set_format_func(vim.inspect)

    local Path = require("pathlib")
    local vls_path = Path.new(require("mason-registry").get_package("vue-language-server"):get_install_path())
    local vue_plugin_path = tostring(vls_path / "node_modules/@vue/language-server")

    ---@diagnostic disable: missing-fields
    local configs = {
        ---@type lspconfig.options.vtsls
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
        ---@type lspconfig.options.clangd
        clangd = {
            settings = {
                clangd = {
                    InlayHints = {
                        Designators = true,
                        Enabled = true,
                        ParameterNames = true,
                        DeducedTypes = true,
                    },
                    -- fallbackFlags = { "-std=c++20" },
                },
            },
        },
        ---@type lspconfig.options.pyright
        pyright = {
            cmd = vim.fn.executable("delance-langserver") and { "delance-langserver", "--stdio" } or nil,
            settings = {
                python = {
                    pythonPath = vim.trim(vim.system({ "pyenv", "which", "python" }):wait().stdout),
                },
            },
        },
        ---@tyipe lspconfig.options.jsonls
        jsonls = {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        },
        ---@type lspconfig.options.yamlls
        yamlls = {
            settings = {
                yaml = {
                    format = {
                        enable = true,
                    },
                },
            },
        },
        ---@type lspconfig.options.qmlls
        qmlls = {
            cmd = { "qmlls6" },
        },
    }
    ---@diagnostic enable: missing-fields

    local function setup_server(server_name)
        local server = lspconfig[server_name]
        local config = vim.tbl_deep_extend("keep", configs[server_name] or {}, {
            capabilities = vim.lsp.protocol.make_client_capabilities(),
        })
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        server.setup(config)
    end

    require("mason-lspconfig").setup_handlers({
        setup_server,
        ["lua_ls"] = function() end,
    })

    setup_server("qmlls")
    setup_server("neocmake")

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            require("which-key").add({
                { "<space>gd", vim.lsp.buf.definition, desc = "goto definition" },
                { "<space>gD", vim.lsp.buf.declaration, desc = "goto declaration" },

                { "<space>e", vim.diagnostic.open_float, desc = "open diagnostic" },
                { "<space>f", smart_format, desc = "format" },
                { "<space>q", vim.diagnostic.setloclist, desc = "diagnostic list" },

                { "<C-k>", vim.lsp.buf.signature_help, desc = "open signature help" },
                buffer = args.buf,
            })
        end,
    })
end
