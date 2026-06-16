vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        if event.data.actions[1].type == "move" then
            Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
        end
    end,
})

-- local last = nil
local is_open = false
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "oil://*",
    callback = function(args)
        -- last = require("oil").get_current_dir()
        is_open = true
    end,
})
vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "oil://*",
    callback = function(args)
        is_open = false
    end,
})

local function toggle_oil()
    if is_open then
        vim.cmd("bdelete")
    else
        if last then
            require("oil").open(last)
        else
            require("oil").open()
        end
    end
end

return {

    {
        'stevearc/oil.nvim',
        ---@type oil.SetupOpts
        lazy = false,

        opts = function()
            -- Declare a global function to retrieve the current directory
            function _G.get_oil_winbar()
                local bufnr = vim.api.nvim_win_get_buf(0)
                local dir = require("oil").get_current_dir(bufnr)
                if dir then
                    return vim.fn.fnamemodify(dir, ":~")
                else
                    -- If there is no current directory (e.g. over ssh), just show the buffer name
                    return vim.api.nvim_buf_get_name(0)
                end
            end

            local detail = false
            return {
                win_options = {
                    winbar = "%{%v:lua.get_oil_winbar()%}",
                },
                keymaps = {
                    ["gd"] = {
                        desc = "Toggle file detail view",
                        callback = function()
                            detail = not detail
                            if detail then
                                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                            else
                                require("oil").set_columns({ "icon" })
                            end
                        end,
                    },
                },
            }
        end,
        -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        keys = {
            { "<leader>b",  toggle_oil, desc = "file explorer" },
            { "<leader>vf", toggle_oil, desc = "file explorer" },
        }
    }

}
