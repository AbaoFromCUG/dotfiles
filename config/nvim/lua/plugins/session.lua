return function()
    local tasks = require("tasks")
    local function close_all_floating_wins()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= '' then
                vim.api.nvim_win_close(win, false)
            end
        end
    end

    local function wrap_tasks(cmds)
        return function()
            local results = {}
            for _, cmd in pairs(cmds) do
                local result = cmd()
                if result then
                    table.insert(results, result)
                end
            end
            return table.concat(results)
        end
    end

    tasks:register_presave_task("close_all_floating_wins", close_all_floating_wins)

    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

    -- need change auto-sesion hook to register
    require("auto-session").setup {
        auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
        pre_save_cmds = { wrap_tasks(tasks.presave_tasks) },
        save_extra_cmds = { wrap_tasks(tasks.saveextra_tasks) },
        post_save_cmds = { wrap_tasks(tasks.postsave_tasks) },
        pre_restore_cmds = { wrap_tasks(tasks.prerestore_tasks) },
        post_restore_cmds = { wrap_tasks(tasks.postrestore_tasks) },
    }
    require("session-lens").setup {
        path_display = { "shorten" },
        previewer = true,
    }
    require("telescope").load_extension "session-lens"
end
