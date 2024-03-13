function DisableBigFile()
    if exists(':TSBufDisable')
        exec 'TSBufDisable autotag'
        exec 'TSBufDisable highlight'
        exec 'TSBufDisable incremental_selection'
        exec 'TSBufDisable indent'
        exec 'TSBufDisable playground'
        exec 'TSBufDisable query_linter'
        exec 'TSBufDisable rainbow'
        exec 'TSBufDisable refactor.highlight_definitions'
        exec 'TSBufDisable refactor.navigation'
        exec 'TSBufDisable refactor.smart_rename'
        exec 'TSBufDisable refactor.highlight_current_scope'
        exec 'TSBufDisable textobjects.swap'
        " exec 'TSBufDisable textobjects.move'
        exec 'TSBufDisable textobjects.lsp_interop'
        exec 'TSBufDisable textobjects.select'
    endif
    echo "Big file"

    set foldmethod=manual
endfunction

augroup BigFileDisable
    autocmd!
    autocmd BufReadPre,FileReadPre * if getfsize(expand("%")) > 512 * 1024 | exec DisableBigFile() | endif
augroup END
