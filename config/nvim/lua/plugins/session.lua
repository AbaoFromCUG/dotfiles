return function()
    require("session-lens").setup {
        path_display = { "shorten" },
        previewer = true,
    }
end
