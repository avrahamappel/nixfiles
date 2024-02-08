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
" Always show the status bar
set laststatus=2
set ruler
set showcmd
set splitright
set splitbelow

" Search options
set ignorecase
set smartcase
set hlsearch
set incsearch

" Theme setup
colorscheme tokyonight-night

" Make comments italic
hi Comment cterm=italic

" Set grepprg to ripgrep
set grepprg=rg\ --column\ --line-number\ --no-heading\ $*

"""""""""""""""""""""""""""""""""""""
" Mappings configuration
"""""""""""""""""""""""""""""""""""""

let g:mapleader = ' '
let g:maplocalleader = ' '

" Why reach for ctrl in normal mode?
map w <C-w>
map <leader>p :Files<CR>
map <leader>b :Buffers<CR>
map <leader>z :History<CR>
" FZF does the filtering
map <leader>f :Rg<CR>
map [q :cprevious<CR>
map ]q :cnext<CR>
map [l :lprevious<CR>
map ]l :lnext<CR>
map <leader>q :copen<CR>:lopen<CR>
map <leader>' :cclose<CR>:lclose<CR>
map <leader>/ :nohlsearch<CR>
" Copy whatever's in " to system clipboard
map <leader>v :let @+=@"<CR>
" Copy current filename to system clipboard ('k' looks like %)
" I might already have a plugin that does this, but I can't find anything
map <leader>k :let @+=@%<CR>
" Copy contents of current file to system clipboard
map <leader>y :%y+<CR>
" Shortcut to open fugitive window. 'n' is close to the spacebar
map <leader>n :Git<CR>
" Shortcut to open db window.
map <leader>d :DBUI<CR>

"""""""""""""""""""""""""""""""""""""
" Plugins settings
"""""""""""""""""""""""""""""""""""""
call camelcasemotion#CreateMotionMappings('c')

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0

let g:rustfmt_autosave = 1

let g:db_ui_debug = 1
let g:db_ui_force_echo_notifications = 1
let g:db_ui_table_helpers = {
\ 'mysql': {
\   'Count': 'select count(*) from {optional_schema}`{table}`'
\ },
\ 'postgres': {
\   'Count': 'select count(*) from {optional_schema}"{table}"'
\ },
\ 'sqlite': {
\   'Count': 'select count(*) from {table}'
\ }
\}
let g:db_ui_auto_execute_table_helpers = 1

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

" Don't add folds in dbout buffers
autocmd FileType dbout setlocal nofoldenable
