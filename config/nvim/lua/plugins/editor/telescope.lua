return function()

    -- stylua: ignore start
    local keys = { 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
        'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
        'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',
        'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', }
    -- stylua: ignore end

    local telescope = require 'telescope'
    local actions = require 'telescope._extensions.hop.actions'
    telescope.setup {
        defaults = {
            prompt_prefix = '🤡',
            -- Default configuration for telescope goes here:
            -- config_key = value,
            --
            layout_config = {
                horizontal = {
                    preview_cutoff = 60
                }
                -- other layout configuration here
            },
            layout_strategy = 'flex',
            mappings = {
                i = {
                    -- IMPORTANT
                    -- either hot-reloaded or `function(prompt_bufnr) telescope.extensions.hop.hop end`
                    ['<C-h>'] = telescope.extensions.hop.hop, -- hop.hop_toggle_selection
                    -- custom hop loop to multi selects and sending selected entries to quickfix list
                    ['<C-l>'] = function(prompt_bufnr)
                        local opts = {
                            callback = actions.toggle_selection,
                            loop_callback = actions.send_selected_to_qflist,
                        }
                        telescope.extensions.hop._hop_loop(prompt_bufnr, opts)
                    end,
                },
            },
        },
        pickers = {
            -- Default configuration for builtin pickers goes here:
            -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
            hop = {
                -- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
                keys = keys,
                -- Highlight groups to link to signs and lines; the below configuration refers to demo
                -- sign_hl typically only defines foreground to possibly be combined with line_hl
                sign_hl = { 'WarningMsg', 'Title' },
                -- optional, typically a table of two highlight groups that are alternated between
                line_hl = { 'CursorLine', 'Normal' },
                -- options specific to `hop_loop`
                -- true temporarily disables Telescope selection highlighting
                clear_selection_hl = false,
                -- highlight hopped to entry with telescope selection highlight
                -- note: mutually exclusive with `clear_selection_hl`
                trace_entry = true,
                -- jump to entry where hoop loop was started from
                reset_selection = true,
            },
        },
    }
    telescope.load_extension 'fzf'
    telescope.load_extension 'hop'
    telescope.load_extension 'dap'
    telescope.load_extension 'frecency'
    telescope.load_extension 'noice'
end
