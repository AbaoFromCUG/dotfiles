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
    { "AbaoFromCUG/cmake-tools.nvim", dev = true },
    {
        "AbaoFromCUG/rust-tools.nvim",
        dev = true,
        opts = {},
    },
    { "Saecki/crates.nvim", opts = {} },
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
        opts = { style = "dark", width = 120 },
    },
    {
        "AckslD/nvim-FeMaco.lua",
        ft = "markdown",
        config = femaco,
    },
    { "nvim-neorg/neorg", config = require("plugins.misc.neorg"), ft = "norg" },
    { "lervag/vimtex", config = tex, ft = "tex" },
    { "rafcamlet/nvim-luapad" },
}
