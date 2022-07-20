-- Auto update packages
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source ~/.config/nvim/lua/plugins.lua | PackerSync
  augroup end
]])

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use "williamboman/nvim-lsp-installer"
  use 'neovim/nvim-lspconfig'

  -- Autocompletions
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'

  -- Theme
  use 'jacoborus/tender.vim'
  use 'morhetz/gruvbox'

  -- Lsp based highlighting for any color theme
  use 'folke/lsp-colors.nvim'


  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }

  -- Show function signatures when typing
  use 'ray-x/lsp_signature.nvim'
  -- Show lsp progress
  use 'j-hui/fidget.nvim'

  use 'tpope/vim-commentary'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- Nix
  use 'lnl7/vim-nix'

  -- Toml
  use 'cespare/vim-toml'

  -- Rust
  -- https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins
  use 'simrat39/rust-tools.nvim'
  -- Debugging
  use 'nvim-lua/plenary.nvim'
  use 'mfussenegger/nvim-dap'
  -- use 'roxma/nvim-cm-racer'
  -- use {
  --   'saecki/crates.nvim',
  --   tag = 'v0.2.0',
  --   requires = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('crates').setup()
  --   end
  -- }

  use 'tpope/vim-sleuth'
end)
