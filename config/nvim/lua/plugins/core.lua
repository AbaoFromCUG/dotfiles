local function profile_start()
    local Path = require("pathlib")
    local profile_path = Path.stdpath("cache", "profile.log")
    ---@diagnostic disable-next-line: param-type-mismatch
    require("plenary.profile").start(tostring(profile_path), { flame = true })
end

local function profile_end()
    local Path = require("pathlib")
    local profile_path = Path.stdpath("cache", "profile.log")
    require("plenary.profile").stop()
    require("plenary.profile").stop()
    if profile_path:is_file() then
        if vim.fn.executable("inferno-flamegraph") then
            local output = vim.fn.system("inferno-flamegraph", tostring(profile_path))
            local flame_path = Path.stdpath("cache", "profile.svg")
            vim.fn.writefile({ output }, tostring(flame_path))
            vim.ui.open(tostring(flame_path))
        end
    end
end

---@type (LazySpec|string)[]
return {
    {
        "nvim-lua/plenary.nvim",
        keys = {
            { "<leader>ps", profile_start, desc = "profile start" },
            { "<leader>pe", profile_end, desc = "profile end" },
        },
    },
    "tami5/sqlite.lua",
    "nvim-tree/nvim-web-devicons",
    "pysan3/pathlib.nvim",
    {
        "mason-org/mason.nvim",
        opts = {
            -- registries = {
            --     "github:fecet/mason-registry",
            -- },
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "VeryLazy" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },

        opts = {
            ensure_installed = {
                "markdownlint",
                "shfmt",
            },
            automatic_installation = true,
        },
    },
}
