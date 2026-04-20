if vim.fn.has("nvim-0.12") ~= 1 then
    return
end

require("vim._core.ui2").enable({
    enable = true, -- Whether to enable or disable the UI.
    msg = { -- Options related to the message module.
        ---@type 'cmd'|'msg' Default message target, either in the
        ---cmdline or in a separate ephemeral message window.
        ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target or table mapping |ui-messages| kinds to a target.
        targets = "cmd",
        timeout = 4000, -- Time a message is visible in the message window.
    },
})
