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
    {
        "AbaoFromCUG/cmake-tools.nvim",
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
        -- build = "cd app && yarn install",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
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
        cmd = { "Neorg" },
        version = "v7.0.0",
        config = neorg,
    },
    {
        "SUSTech-data/neopyter",
        cmd = { "Neopyter" },
        ft = { "python" },
        lazy = true,
        enable = false,
        opts = {
            remote_address = "127.0.0.1:9001",
            auto_attach = true,
            on_attach = function(buf)
                require("keymap.notebookbuf")(buf)
            end,
            highlight = {
                enable = false,
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
        opts = {},
    },
    { "lambdalisue/suda.vim" },
}
