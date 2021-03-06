return function()
    vim.g.toggleterm_terminal_mapping = "C-t"

    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<C-t>", "<Cmd>exec v:count1 . 'ToggleTerm'<CR>", opts)
    --vim.api.nvim_set_keymap("i", "<C-t><Esc>", "<Cmd>exec v:count1 . 'ToggleTerm'<CR>", opts)
    function _G.set_terminal_keymaps()
        vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

    require("toggleterm").setup {
        -- size can be a number or function which is passed the current terminal
        size = 15,
        -- open_mapping = [[<leader><leader>m]],
        hide_numbers = false, -- hide the number column in toggleterm buffers
        shade_terminals = true,
        -- shading_factor = '<1>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = false, -- whether or not the open mapping applies in insert mode
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true, -- close the terminal window when the process exits
        shell = vim.o.shell, -- change the default shell
    }
end
