require("which-key").add({
    { "<leader>ll", "<cmd>MarkdownPreviewToggle<cr>", desc = "preview markdown" },
    buffer = 0,
})

local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_autocmd("InsertEnter", {
    buffer = bufnr,
    once = true,
    callback = function(args)
        require("otter").activate()
    end
})
