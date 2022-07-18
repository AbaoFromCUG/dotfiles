" copy to system clipboard
vmap <leader>y "+y

" paste to vim register
nnoremap <leader>p "+p


nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()
