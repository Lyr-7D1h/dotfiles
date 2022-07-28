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

  -- Snipets
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
  use 'tomasiser/vim-code-dark'
  use 'Mofiqul/vscode.nvim'

  use 'kyazdani42/nvim-web-devicons'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }

  -- Show error lines
  use({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  })

  -- Show git blame on current line
  use 'tveskag/nvim-blame-line'

  -- Show lsp progress
  use 'j-hui/fidget.nvim'

  -- Autocomplete pairs
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
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
