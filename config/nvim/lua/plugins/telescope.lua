if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end
return function()
  local actions = require('telescope.actions')
  require('telescope').setup({
    defaults = {
      mappings = {
        i = {
          -- IMPORTANT
          -- either hot-reloaded or `function(prompt_bufnr) telescope.extensions.hop.hop end`
          ["<C-h>"] = R("telescope").extensions.hop.hop, -- hop.hop_toggle_selection
          -- custom hop loop to multi selects and sending selected entries to quickfix list
          ["<C-space>"] = function(prompt_bufnr)
            local opts = {
              callback = actions.toggle_selection,
              loop_callback = actions.send_selected_to_qflist
            }
            require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
          end
        }
      }
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = false, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      hop = {
        -- keys define your hop keys in order; defaults to roughly lower- and uppercased home row
        -- keys = { "a", "s", "d", "f", "g", "h", "j", "k", "l", ";"}, -- ... and more

        -- Highlight groups to link to signs and lines; the below configuration refers to demo
        -- sign_hl typically only defines foreground to possibly be combined with line_hl
        -- sign_hl = { "WarningMsg", "Title" },
        -- optional, typically a table of two highlight groups that are alternated between
        -- line_hl = { "CursorLine", "Normal" },
        -- options specific to `hop_loop`
        -- true temporarily disables Telescope selection highlighting
        -- clear_selection_hl = false,
        -- highlight hopped to entry with telescope selection highlight
        -- note: mutually exclusive with `clear_selection_hl`
        trace_entry = true,
        -- jump to entry where hoop loop was started from
        reset_selection = true
      },
      fzf_writer = {
        minimum_grep_characters = 2,
        minimum_files_characters = 2,

        -- Disabled by default.
        -- Will probably slow down some aspects of the sorter, but can make color highlights.
        -- I will work on this more later.
        use_highlighter = true
      }
    }
  })
  require('telescope').load_extension('project')
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('hop')
  require('telescope').load_extension('dap')
end
