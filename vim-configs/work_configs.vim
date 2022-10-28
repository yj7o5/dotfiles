" NOTE: update this to point to your discord root directory
let s:discoHome = $HOME . '/discord/discord'

func! s:OnFormatted(tempFilePath, _buffer, _output)
    return readfile(a:tempFilePath)
endfunc

func! FormatDiscoPython(buffer, lines) abort
    " NOTE: clyde's python format will ONLY operate correctly on a file
    " if it lives in the same discord repo root that clid does, so
    " we have to manually create the temp file/directory here:

    let dir = s:discoHome . '/.ale-tmp'
    if !isdirectory(dir)
        call mkdir(dir)
    endif
    call ale#command#ManageDirectory(a:buffer, dir)

    " this may be overkill, but just in case:
    let filename = localtime() . '-' . rand() . '-' . bufname(a:buffer)
    let path = dir . '/' . filename
    call writefile(a:lines, path)

    let blackw = s:discoHome . '/tools/blackw'
    let command = blackw . ' ' . path
    return {
        \ 'command': command,
        \ 'read_buffer': 0,
        \ 'process_with': function('s:OnFormatted', [path]),
        \ }
endfunc

call ale#fix#registry#Add('clyde-format', 'FormatDiscoPython', ['python'], 'clyde formatting for python')

"
" javascript/typescript ale linting
"
let g:ale_sign_error = '▻'
let g:ale_sign_warning = '•'
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 100
" use eslint_d instead of the local eslint for speed!
" `yarn global add eslint_d`
" NOTE: if you upgrade your eslint version, run
" `eslint_d restart`
let g:ale_javascript_eslint_executable = 'eslint_d'
" so that we prefer eslint_d over the local version :\
let g:ale_javascript_eslint_use_global = 1
" setup ale autofixing
let g:ale_fixers = {}
let g:ale_fixers.javascript = [
\ 'eslint',
\ 'prettier',
\]
let g:ale_fixers.css = [
\ 'prettier',
\]
let g:ale_fix_on_save = 1
" handy key mappings to move to the next/previous error
nnoremap [; :ALEPreviousWrap<cr>
nnoremap ]; :ALENextWrap<cr>

command! -nargs=* -complete=dir FzfJumpToDir call fzf#run(fzf#wrap('zoxide', {
    \ 'source': 'fd . --type directory ' . s:discoHome,
    \ 'sink': funcref('zoxide#handle_select_result', ['cd'])}))
nnoremap <silent> <space><space> :FzfJumpToDir<cr>
nnoremap <silent> <space>h :FzfJumpToDirHidden<cr>
