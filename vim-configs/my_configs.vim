" ability to click with mouse
set mouse=a

" cd to directory of current file and print out new cur dir
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" make the screen pretty
syntax on
set noshowmode " no longer need to show INSERT as it's on the status bar
set relativenumber
set t_Co=256 " lots of colors here
set laststatus=2
silent! colorscheme gruvbox
set background=dark
hi Search cterm=NONE ctermfg=black ctermbg=red

" search related
set hlsearch " highlight search
set incsearch
set ignorecase

" indentation logic
filetype indent on
filetype plugin indent on
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent
set backspace=indent,eol,start
" highlight tabs
highlight SpecialKey ctermfg=1
set list
set listchars=tab:T>

" excludes from fuzzy find
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*target*

" keep vim history after closing
set undofile
set noswapfile
set undodir=~/.vim/temp_dirs/undodir

"""""""""""""""""""""
" Trailing Whitespace
"""""""""""""""""""""
fun! CleanExtraSpace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfun

" Delete on save for some filetypes
if has("autocmd")
  autocmd BufWritePre *.txt,*.js,*.py,*.java,*.yml.erb,*.rs,*.scala,*.yml,*.yaml,*.conf,*.rb :call CleanExtraSpace()
endif

" highlight it
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Update time
set updatetime=100


"""""""""""""""""""""
" custom key mappings
"""""""""""""""""""""
let mapleader = ","

" allow sourcing of vim without re-opening
map <leader>s :source ~/.vimrc<CR>

" window controls
" maximize window vertically
map <leader>- <C-w>_
" equalize windows
map <leader>= <C-w>=

" temporarily expand current window
:noremap tt :tab split<CR>
" equalize the windows
:noremap == <C-w>=

" map spacebar to search
map <Space> /

" remove highlights quickly
map ; :noh<CR>

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" remember cursor position using above viminfo settings
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" line numbers
" ensure both line number and relative are set
set number
set relativenumber

fun! ToggleLineNumbers()
  set number!
  set relativenumber!
endfun

map <leader>l :call ToggleLineNumbers()<CR>

if has('macunix')
  vmap <C-c> :w !pbcopy<CR><CR>
  nmap <C-c> :.w !pbcopy<CR><CR>
  " don't use this until you find alternative for visual block mode
  "noremap <C-v> :r !pbpaste<CR><CR>
endif
