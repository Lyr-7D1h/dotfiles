call plug#begin()
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'

Plug 'lnl7/vim-nix'

Plug 'cespare/vim-toml'

Plug 'rust-lang/rust.vim'
Plug 'roxma/nvim-cm-racer'

Plug 'tpope/vim-sleuth'
call plug#end()

set number
set tabstop=4
set shiftwidth=4
set clipboard+=unnamedplus
set encoding=utf-8

let mapleader=";"
