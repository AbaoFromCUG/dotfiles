return function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

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

    local is_inside_work_tree = {}
    local function project_files()
        local cwd = vim.uv.cwd()
        if cwd and is_inside_work_tree[cwd] == nil then
            vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true, cwd = cwd }, function(out)
                is_inside_work_tree[cwd] = out.code == 0
                vim.schedule(project_files)
            end)
        end
        if is_inside_work_tree[cwd] then
            builtin.git_files({ use_git_root = false, show_untracked = true })
        else
            builtin.find_files()
        end
    end
    vim.keymap.set("n", "<leader>ff", project_files, { desc = "find files" })
    vim.keymap.set("n", "<leader>fh", builtin.oldfiles, { desc = "find files" })
    vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "find files" })
    vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "find files" })
end
