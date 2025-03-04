set nocompatible
syntax on
set re=0
set encoding=utf8
set hidden

" OSX stupid backspace fix
set backspace=indent,eol,start

" Enable mouse control
set mouse=nv

" Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Editor appearance
set number
set signcolumn=number
set cursorline
set cursorlineopt=number
" Always show the status bar
set laststatus=2
set ruler
set showcmd
set splitright
set splitbelow
set listchars=tab:<->,space:·,nbsp:+

" Search options
set ignorecase
set smartcase
set hlsearch
set incsearch

" Make comments italic
hi Comment cterm=italic

" Set grepprg to ripgrep
set grepprg=rg\ --column\ --line-number\ --no-heading\ $*

"""""""""""""""""""""""""""""""""""""
" Mappings configuration
"""""""""""""""""""""""""""""""""""""

" Why reach for modifier keys in normal mode?
map <leader>w <C-w>
map <leader>; :

map [q :cprevious<CR>
map ]q :cnext<CR>
map [l :lprevious<CR>
map ]l :lnext<CR>
map <leader>q :copen<CR>:lopen<CR>
map <leader>' :cclose<CR>:lclose<CR>
map <leader>/ :nohlsearch<CR>

" COPYING
" Copy whatever's in " to system clipboard
map <leader>v :let @+=@"<CR>
" Copy current filename to system clipboard ('k' looks like %)
map <leader>k :let @+=@%<CR>
" Copy current file and line to system clipboard
map <leader>m :let @+=@%.':'.line('.')<CR>
" Copy contents of current file to system clipboard
map <leader>y :%y+<CR>

"""""""""""""""""""""""""""""""""""""
" Autocmds
"""""""""""""""""""""""""""""""""""""

" Go to insert mode when entering terminal buffer
augroup neovim_terminal
    autocmd!
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber
augroup END

" Remap exiting terminal. Less useful than it sounds
" tnoremap <A-q> <C-\><C-n>

" Enable pasting from registers in terminal mode
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
