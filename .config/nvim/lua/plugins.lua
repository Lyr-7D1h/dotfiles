-- Install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

-- Auto update packages on saving this file
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

  -- Fold functions based on lsp and treesitter
  use {
    "kevinhwang91/nvim-ufo",
    opt = true,
    event = { "BufReadPre" },
    wants = { "promise-async" },
    requires = "kevinhwang91/promise-async",
    config = function()
      require("ufo").setup {
        provider_selector = function(bufnr, filetype)
          return { "lsp", "indent" }
        end,
      }
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end,
  }

  -- Packer
  use({
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup({
        keymaps = {
          close = { "<C-c>", "<Esc>" },
          yank_last = "<C-y>",
          scroll_up = "<C-u>",
          scroll_down = "<C-d>",
          toggle_settings = "<C-o>",
          new_session = "<C-n>",
          cycle_windows = "<Tab>",
        },
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  })


  -- Snipets
  -- Auto complete framework
  use 'hrsh7th/nvim-cmp'
  -- Lsp Completion Sources
  use 'hrsh7th/cmp-nvim-lsp'
  -- Completion sources
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'

  -- Theme
  use 'jacoborus/tender.vim'
  use 'morhetz/gruvbox'
  use 'tomasiser/vim-code-dark'
  use 'Mofiqul/vscode.nvim'
  use 'tanvirtin/monokai.nvim'
  use 'navarasu/onedark.nvim'

  -- Treesitter
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup()
    end

  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use 'nvim-treesitter/nvim-treesitter-context'

  -- Lsp
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'MunifTanjim/prettier.nvim'


  -- Show error lines
  -- use({
  --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   config = function()
  --     require("lsp_lines").setup()
  --   end,
  -- })

  -- Show git blame on current line
  use 'tveskag/nvim-blame-line'

  -- Show lsp progress
  use 'j-hui/fidget.nvim'

  -- Autocomplete pairs
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
  -- use 'tpope/vim-commentary'
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- use 'junegunn/fzf'
  -- use 'junegunn/fzf.vim'

  -- Nix
  use 'lnl7/vim-nix'

  -- Toml
  use 'cespare/vim-toml'

  use 'jose-elias-alvarez/typescript.nvim'

  -- Rust
  -- https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins
  use 'simrat39/rust-tools.nvim'
  -- Debugging
  use 'nvim-lua/plenary.nvim'
  use 'mfussenegger/nvim-dap'
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
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
