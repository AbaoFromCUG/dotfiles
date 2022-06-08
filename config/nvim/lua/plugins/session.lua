return function()
    local nvim_tree = require "nvim-tree"
    local function restore_nvim_tree()
        nvim_tree.change_dir(vim.fn.getcwd())
    end

    require("auto-session").setup {
        auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
        post_restore_cmds = { restore_nvim_tree },
    }
    require("session-lens").setup {
        path_display = { "shorten" },
        previewer = true,
    }
    require("telescope").load_extension "session-lens"
end
