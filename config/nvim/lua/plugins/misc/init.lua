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
        ft = "markdown",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "AckslD/nvim-FeMaco.lua",
        ft = "markdown",
        config = femaco,
    },
    { "nvim-neorg/neorg", config = require("plugins.misc.neorg"), ft = "norg" },
    {
        "SUSTech-data/neopyter",
        opts = {
            auto_attach = true,
            rpc_client = "async",
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
}
