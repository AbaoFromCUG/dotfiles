" terminal
nnoremap <silent><C-t><C-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
tnoremap <silent><C-t><C-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
tnoremap <silent><C-t><C-r> <C-\><C-n>

" dap
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <F9> :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <C-F9> :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <C-A-F9>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>

