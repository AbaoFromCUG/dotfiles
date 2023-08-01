return function()
    require("toggleterm").setup({
        -- size can be a number or function which is passed the current terminal
        size = 15,
        open_mapping = [[<C-t>]],
        hide_numbers = false, -- hide the number column in toggleterm buffers
        shade_terminals = true,
        -- shading_factor = '<1>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = false, -- whether or not the open mapping applies in insert mode
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true, -- close the terminal window when the process exits
        shell = vim.o.shell, -- change the default shell
    })
end
