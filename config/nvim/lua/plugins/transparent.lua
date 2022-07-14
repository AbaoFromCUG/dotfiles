return function()
    require("transparent").setup {
        enable = false,
        extra_groups = {
            "BufferLineTabClose",
            "BufferlineBufferSelected",
            "BufferLineFill",
            "BufferLineBackground",
            "BufferLineSeparator",
            "BufferLineIndicatorSelected",
        },
    }

    vim.api.nvim_create_autocmd("FocusGained", {
        pattern = { "*" },
        callback = function()
            vim.cmd("TransparentDisable")
        end
    })
    vim.api.nvim_create_autocmd("FocusLost", {
        pattern = { "*" },
        callback = function()
            vim.cmd("TransparentEnable")
        end
    })


end
