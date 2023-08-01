return function()
    local builtin = require("telescope.builtin")
    local fn = vim.fn

    local function format_desc(name)
        return string.format(" %-50s", name)
    end

    local plugin_count = require("lazy").stats().count
    local version = vim.version()

    require("dashboard").setup({
        -- config
        theme = "doom",
        config = {
            center = {
                {
                    icon = "📦",
                    desc = format_desc("Restore session"),
                    action = function()
                        vim.api.nvim_command("Autosession search")
                    end,
                    key = "s",
                    keymap = "SPC f s",
                },
                {
                    icon = "🔭",
                    desc = format_desc("Find File"),
                    action = function()
                        builtin.find_files({})
                    end,
                    key = "f",
                    keymap = "SPC f f",
                },
                {
                    icon = "📖",
                    desc = format_desc("Recently opend files"),
                    action = function()
                        builtin.oldfiles({})
                    end,
                    key = "h",
                    keymap = "SPC f h",
                },
                {
                    icon = "🔠",
                    desc = format_desc("Find words"),
                    action = function()
                        builtin.live_grep({})
                    end,
                    key = "w",
                    keymap = "SPC f w",
                },
                {
                    icon = "📌",
                    desc = format_desc("Find marks"),
                    action = function()
                        builtin.marks({})
                    end,
                    key = "m",
                    keymap = "SPC f m",
                },
            },
            footer = {
                string.format("🛸 loaded %d plugins", plugin_count),
                string.format("🔖%d.%d.%d", version.major, version.minor, version.patch),
            },
        },
        preview = {
            command = "cat",
            file_path = fn.stdpath("config") .. "/share/nvim.cat",
            file_width = 20,
            file_height = 10,
        },
    })
end
