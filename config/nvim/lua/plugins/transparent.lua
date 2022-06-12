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
end
