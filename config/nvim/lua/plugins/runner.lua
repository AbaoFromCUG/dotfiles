return {

    {
        "stevearc/overseer.nvim",
        cmd = { "OverseerToggle", "OverseerInfo", "OverseerRun" },
        dependencies = "toggleterm.nvim",
        -- version = "v1.6.0",
        opts = {
            templates = { "builtin", "devcontainer" },
            ---@diagnostic disable-next-line: assign-type-mismatch
            strategy = {
                "toggleterm",
                direction = "float",
                close_on_exit = false,
                quit_on_exit = "never",
                -- use_shell = true,
            },
        },
        config = function(_, opts)
            require("overseer").setup(opts)
            require("overseer.shell").escape_cmd = function(cmd)
                cmd = table.concat(vim.tbl_map(vim.fn.shellescape, cmd), " ")
                return cmd
            end
        end,
    },
    {
        "AbaoFromCUG/session.nvim",
        opts = {
            hooks = {
                extra_save = {
                    save_overseer = function()
                        local tasks = require("overseer.task_list").list_tasks()
                        local cmds = {}
                        for _, task in ipairs(tasks) do
                            local json = vim.json.encode(task:serialize())
                            -- For some reason, vim.json.encode encodes / as \/.
                            json = string.gsub(json, "\\/", "/")
                            -- Escape single quotes so we can put this inside single quotes
                            json = string.gsub(json, "'", "\\'")
                            table.insert(cmds, string.format("lua require('overseer').new_task(vim.json.decode('%s')):start()", json))
                        end
                        return table.concat(cmds, "\n")
                    end,
                },
                post_save = {},
                pre_restore = {
                    dispose_overseer_tasks = function()
                        for _, task in ipairs(require("overseer").list_tasks({})) do
                            task:dispose(true)
                        end
                    end,
                },
                post_restore = {},
            },
        },
    }
}
