set encoding=UTF-8

" Index using spaces instead of tabs
set expandtab

" The number of spaces to use for each indent
set shiftwidth=4

" Auto indent on next line using previous lines indent
set autoindent 

" The number of spaces to use for a <Tab> using editing operations
set softtabstop=4

" Disable document word wrap
set nowrap

" Up and down wrapped lines
map j gj
map k gk

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle file drawer in/out
map nf :NERDTreeFind<CR>
nmap nt :NERDTreeToggle<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Document
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap fd gg=G<CR>

" Files Syntax Highlight
syntax on

" Highlight search matches
set hlsearch

" Clear search with shift+enter
nnoremap <S-x> :noh<CR>

" Highlight cursor line
set cursorline

" Search in files
noremap <silent> <Leader>f :Rg<CR>

" Mappings for moving lines and preserving indentation
" http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Hybrid Line relative numbers 
set number relativenumber

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Dont open when only single file selected
let g:NERDTreeQuitOnOpen = 0
" Remove extra noise on UI
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeIgnore=['__pycache__', 'node_modules', '\~$']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Code Completion (CoC 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_disable_startup_warning = 1
let g:coc_global_extensions=['coc-omnisharp', 'coc-python']

" Symbol 'rn' renaming 
nmap <Leader>rn <Plug>(coc-rename)

" Use tab for trigger completion with characters ahead and 
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin(expand('~/.vim/plugged'))
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'mhinz/vim-startify'
Plug 'junegunn/goyo.vim'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme nord

" Disable go auto formatting after file save (currently prompting errors)
let g:go_fmt_autosave = 0

" Needed to enable Go specific commands
filetype plugin on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" References Guide
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" Tmux:
" :resize-pane [-U|-D|-L|-R] [Number|Percentage] - ex: :resize-pane -R 20%
" 
" ZenMode:
" :Goyo - toggle goyo 
" :Goyo - turn on or resize goyo
" :Goyo - Turn goyo off
"
" Movement:
" H - top of window
" M - middle of window
" L - bottom of window
"
" Search:
" :Rg [Pattern] - To search in files or <Leader>f