return function()
    local fn = vim.fn

    local function format_desc(name)
        return string.format(" %-50s", name)
    end

    local plugin_count = require("lazy").stats().count

    require("dashboard").setup({
        -- config
        theme = "doom",
        config = {
            center = {
                {
                    icon = "📦",
                    desc = format_desc("Restore session"),
                    action = function()
                        vim.api.nvim_command("Session open")
                    end,
                    key = "s",
                    keymap = "SPC f s",
                },
                {
                    icon = "🔭",
                    desc = format_desc("Find File"),
                    action = function()
                        local builtin = require("telescope.builtin")
                        builtin.find_files({})
                    end,
                    key = "f",
                    keymap = "SPC f f",
                },
                {
                    icon = "📖",
                    desc = format_desc("Recently opend files"),
                    action = function()
                        local builtin = require("telescope.builtin")
                        builtin.oldfiles({})
                    end,
                    key = "h",
                    keymap = "SPC f h",
                },
                {
                    icon = "🔠",
                    desc = format_desc("Find words"),
                    action = function()
                        local builtin = require("telescope.builtin")
                        builtin.live_grep({})
                    end,
                    key = "w",
                    keymap = "SPC f w",
                },
                {
                    icon = "📌",
                    desc = format_desc("Find marks"),
                    action = function()
                        local builtin = require("telescope.builtin")
                        builtin.marks({})
                    end,
                    key = "m",
                    keymap = "SPC f m",
                },
            },
            footer = {
                string.format("🛸 loaded %d plugins", plugin_count),
                tostring(vim.version()),
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
