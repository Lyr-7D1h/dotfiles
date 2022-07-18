-- Auto update packages
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source ~/.config/nvim/lua/plugins.lua | PackerSync
  augroup end
]])

return require('packer').startup(function()
        use "williamboman/nvim-lsp-installer"
        use 'wbthomason/packer.nvim'

        -- Autocompletions
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/nvim-cmp'

        use {
            'nvim-treesitter/nvim-treesitter',
            run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        }

        use 'tpope/vim-commentary'
        use 'jiangmiao/auto-pairs'
        use 'junegunn/fzf'
        use 'junegunn/fzf.vim'
        use 'neovim/nvim-lspconfig'

        use 'lnl7/vim-nix'

        use 'cespare/vim-toml'

        -- use 'rust-lang/rust.vim'
        -- https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins
        use 'simrat39/rust-tools.nvim'
        -- Debugging
        use 'nvim-lua/plenary.nvim'
        use 'mfussenegger/nvim-dap'
        -- use 'roxma/nvim-cm-racer'

        use 'tpope/vim-sleuth'
end)
