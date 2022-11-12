"
" OPTIONS
"
set number
set tabstop=4
set shiftwidth=4
set clipboard+=unnamedplus
set encoding=utf-8
set scrolloff=8
set mouse=a
set completeopt=menu,menuone,noselect
set noswapfile

" Disable automatically wrapping newline 
set formatoptions-=t

set relativenumber

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
