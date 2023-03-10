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
colorscheme molokai

hi Comment cterm=italic

"""""""""""""""""""""""""""""""""""""
" Mappings configuration
"""""""""""""""""""""""""""""""""""""

" Make fzf delegate to ripgrep
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --no-ignore-vcs --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

let g:mapleader = ' '
let g:maplocalleader = ' '

map <leader>p :Files<CR>
map <leader>b :Buffers<CR>
map <leader>z :History<CR>
" FZF does the filtering
map <leader>f :Rg<CR>
" Delegates to ripgrep and searches in ignored directories
map <leader>g :RG<CR>
map [q :cprevious<CR>
map ]q :cnext<CR>
map [l :lprevious<CR>
map ]l :lnext<CR>
map <leader>q :copen<CR>:lopen<CR>
map <leader>' :cclose<CR>:lclose<CR>
map <leader>/ :nohlsearch<CR>
" Copy whatever's in " to system clipboard
map <leader>v :let @*=@"<CR>

"""""""""""""""""""""""""""""""""""""
" Plugins settings
"""""""""""""""""""""""""""""""""""""

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0

let g:rustfmt_autosave = 1

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
