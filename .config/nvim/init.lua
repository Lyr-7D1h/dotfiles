-- comma as leader
vim.g.mapleader = " "

vim.cmd([[
	so ~/.config/nvim/legacy.vim
]])

if vim.fn.exists('g:vscode') == 0 then
	-- Load all plugins when not in vscode
	require('plugins')
	require('mylsp')
	require('autocmp')

	-- Disable text after line cause we're using lsp_lines
	vim.diagnostic.config({
		virtual_text = false,
	})


	vim.keymap.set('n', '<C-p>', ':GFiles<CR>')
	vim.keymap.set('n', '<C-g>', ':Rg<CR>')
	-- This unsets the "last search pattern" register by hitting escape
	vim.keymap.set('n', '<esc>', ':noh<CR><esc>')
	vim.keymap.set('n', '<esc>^[', '<esc>^[')

	vim.keymap.set('n', '<leader>b', ':ToggleBlameLine<CR>')

	-- Theming
	-- vim.cmd("set termguicolors")
	-- vim.cmd("colorscheme tender")
	-- vim.cmd("autocmd vimenter * ++nested colorscheme gruvbox")
	vim.cmd("colorscheme codedark")
	-- vim.o.background = 'dark'
	-- require('vscode').setup({})

	-- TODO setup keybind
	-- require 'nvim-web-devicons'.setup {}
	-- require("nvim-tree").setup()
	-- vim.keymap.set('n', '<C-e>', ':NvimTreeToggle<CR>')
	vim.keymap.set('n', '<C-e>', ':Explore<CR>')

	require "fidget".setup {}

	-- nvim-treesitter
	require('nvim-treesitter.configs').setup {
		ensure_installed = { 'comment' },
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	}
end
