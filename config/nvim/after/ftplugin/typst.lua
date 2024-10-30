require("which-key").add({
    { "<leader>ll", "<cmd>TypstPreview<cr>", desc = "typst preview" },
    { "<leader>lt", "<cmd>TypstPreviewToggle<cr>", desc = "typst preview toggle" },
    { "<leader>ls", "<cmd>TypstPreviewStop<cr>", desc = "typst preview stop" },
    { "<leader>ls", "<cmd>TypstPreviewFollowCursor<cr>", desc = "typst follow cursor" },
    buffer = 0,
})
