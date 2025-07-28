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
            { "<leader>pe", profile_end,   desc = "profile end" },
        },
    },
    "tami5/sqlite.lua",
    "nvim-tree/nvim-web-devicons",
    "pysan3/pathlib.nvim",
    "AbaoFromCUG/websocket.nvim",

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
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = function()
            return {
                bigfile = {
                    size = 5 * 1024 * 1024,
                },
                image = {
                    enabled = true,
                },
                indent = {
                    enabled = true,
                    hl = {
                        "SnacksIndent1",
                        "SnacksIndent2",
                        "SnacksIndent3",
                        "SnacksIndent4",
                        "SnacksIndent5",
                        "SnacksIndent6",
                        "SnacksIndent7",
                        "SnacksIndent8",
                    },
                },
                input = {
                    enabled = true,
                },
                picker = {
                    ui_select = true,
                    formatters = {
                        file = {

                            -- filename_only = true,
                            truncate = 60,
                        },
                    },
                },

                notifier = {
                },
                scroll = { enabled = true },
                statuscolumn = {
                    left = { "sign", "git" },
                    right = { "fold" },
                    -- right = { "mark" },
                    folds = {
                        open = true,
                        git_hl = true,
                    },
                    git = {
                        -- patterns to match Git signs
                        patterns = { "GitSign", "MiniDiffSign" },
                    },
                    refresh = 50, -- refresh at most every 50ms
                },
                styles = {
                    notification = { focusable = false },

                    input = {
                        relative = "cursor",
                        row = -3,
                        col = 0,
                        keys = {
                            i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
                        },
                        b = {
                            completion = true
                        }
                    },
                },
            }
        end,
        keys = {
            { "<leader>fp", function() Snacks.picker() end,                                         desc = "find find" },
            { "<leader>ff", function() Snacks.picker.files({ ignored = false, hidden = true }) end, desc = "find files" },
            { "<leader>fh", function() Snacks.picker.recent() end,                                  desc = "find history" },
            { "<leader>fw", function() Snacks.picker.grep({ regex = false }) end,                   desc = "find word" },
            -- git
            { "<leader>gB", function() Snacks.gitbrowse() end,                                      desc = "git browse" },
            { "<leader>gl", function() Snacks.lazygit.log() end,                                    desc = "lazygit log" },

            { "<leader>nm", function() Snacks.notifier.hide() end,                                  desc = "dismiss all notifications" },
            { "<leader>nl", function() Snacks.notifier.show_history() end,                          desc = "show all notifications" },

            { ";x",         function() Snacks.bufdelete() end,                                      desc = "close current buffer" },
            { "<leader>vq", function() Snacks.bufdelete.delete()() end,                             desc = "close current buffer" },
            { "<leader>vo", function() Snacks.bufdelete.other() end,                                desc = "close others buffer" },

            { "<leader>zz", function() Snacks.zen.zen() end,                                        mode = { "n", "i", "v" },          desc = "zen mode" },
        },
    },

}
