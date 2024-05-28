return function()
    local telescope = require("telescope")

    telescope.setup({
        defaults = {
            prompt_prefix = "🤡",
            -- Default configuration for telescope goes here:
            -- config_key = value,
            --
            layout_config = {
                horizontal = {
                    preview_cutoff = 60,
                },
                -- other layout configuration here
            },
            layout_strategy = "flex",
            mappings = {},
        },
        pickers = {
            find_files = {
                hidden = true,
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
        },
    })
    telescope.load_extension("fzf")
    telescope.load_extension("frecency")
    telescope.load_extension("session")
end
