return function()
    local dap = require "dap"
    local opts = { noremap = true }
    vim.api.nvim_set_keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<F12>", ":lua require'dap'.step_out()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<F9>", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-F9>", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
    vim.api.nvim_set_keymap("n", "<C-A-F9>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
    vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", opts)
    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode", -- adjust as needed
        name = "lldb",
    }

    dap.adapters.node2 = {
        name = "node2",
        type = "executable",
        command = "node",
        args = {
            "/Volumes/Demon/github/vscode-node-debug2/out/src/nodeDebug.js",
        },
    }
end
