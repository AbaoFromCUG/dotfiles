local function mason()
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    })
end

local function mason_lspconfig()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "pyright",
            "vimls",
            "bashls",
            "clangd",
            "jsonls",
            "yamlls",
            "neocmake",
            "html",
            "cssls",
            "tsserver",
            "volar",
            "texlab",
            "marksman",
            "taplo",
            "ruff_lsp",
            "tailwindcss",
        },
        automatic_installation = true,
    })
end

local function mason_dap()
    require("mason-nvim-dap").setup({
        ensure_installed = { "cppdbg" },
        automatic_installation = true,
    })
end

local function mason_null_ls()
    require("mason-null-ls").setup({
        ensure_installed = {},
        automatic_installation = true,
    })
end

local function cmake()
    -- register command
    require("cmake-tools").setup({
        cmake_build_directory = "build",
        cmake_soft_link_compile_commands = false,
        cmake_dap_configuration = { -- debug settings for cmake
            name = "cpp",
            type = "cppdbg",
            request = "launch",
            stopOnEntry = false,
            runInTerminal = true,
            console = "integratedTerminal",
        },
        cmake_always_use_terminal = false,
        cmake_quickfix_opts = { -- quickfix settings for cmake, quickfix will be used when `cmake_always_use_terminal` is false
            show = "only_on_error", -- "always", "only_on_error"
            position = "belowright", -- "bottom", "top"
            size = 10,
        },
    })
end

local function femaco()
    require("femaco").setup({
        create_tmp_filepath = function(filetype)
            return string.format("%s/.femaco_%d_%s", vim.fn.getcwd(), math.random(100, 999), filetype)
        end,
    })
end

local function neorg()
    require("neorg").setup({
        load = {
            ["core.defaults"] = {},
            ["core.journal"] = {
                config = {
                    workspace = "notes",
                },
            },

            ["core.completion"] = { config = { engine = "nvim-cmp" } },
            ["core.concealer"] = {},
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/Documents/notes",
                    },
                    autochdir = true,
                    index = "index.norg",
                },
            },
            ["core.export"] = {},
            ["core.export.markdown"] = {},
            ["core.presenter"] = {
                config = {
                    zen_mode = "truezen",
                },
            },
        },
    })
end

local function tex()
    vim.g.vimtex_view_method = "zathura"
end

return {
    -- installer
    { "williamboman/mason.nvim", config = mason },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "mason.nvim",
        config = mason_lspconfig,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        config = mason_dap,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = mason_null_ls,
    },
    {
        "AbaoFromCUG/cmake-tools.nvim",
    },
    {
        "AbaoFromCUG/rust-tools.nvim",
        opts = {},
    },
    { "Saecki/crates.nvim", opts = {} },
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
        opts = { style = "dark", width = 120 },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "AckslD/nvim-FeMaco.lua",
        ft = "markdown",
        config = femaco,
    },
    {
        "nvim-neorg/neorg",
        version = "v7.0.0",
        config = neorg,
    },
    {
        "SUSTech-data/neopyter",
        opts = {
            remote_address = "127.0.0.1:9001",
            auto_attach = true,
            highlight = {
                enable = true,
                shortsighted = false,
            },
        },
    },
    { "lervag/vimtex", config = tex, ft = "tex" },
    { "rafcamlet/nvim-luapad" },
    {
        "glacambre/firenvim",
        build = function()
            vim.fn["firenvim#install"](0)
        end,
    },
    "LunarVim/bigfile.nvim",
    {
        "luckasRanarison/tailwind-tools.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            conceal = {
                enabled = true,
            },
        },
    },
}
