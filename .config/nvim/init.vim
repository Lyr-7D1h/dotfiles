call plug#begin()
Plug 'tpope/vim-commentary'
Plug 'rust-lang/rust.vim'
Plug 'lnl7/vim-nix'
Plug 'cespare/vim-toml'
Plug 'jiangmiao/auto-pairs'
Plug 'roxma/nvim-cm-racer'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-sleuth'
call plug#end()

set number
set tabstop=4
set shiftwidth=4
set clipboard+=unnamedplus

let mapleader=";"

" " Always use original yank when pasting
" noremap <Leader>p "0p
" noremap <Leader>P "0P
" vnoremap <Leader>p "0p

" " Easier Split Navigation
" nnoremap <C-j> <C-W><C-J>
" nnoremap <C-k> <C-W><C-K>
" nnoremap <C-l> <C-W><C-L>
" nnoremap <C-h> <C-W><C-H>
