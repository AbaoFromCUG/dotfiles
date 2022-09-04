" copy to system clipboard
nnoremap <leader>y "+y

" paste to vim register
nnoremap <leader>p "+p


nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()
