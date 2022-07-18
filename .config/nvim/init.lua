-- comma as leader
vim.g.mapleader = " "

vim.cmd([[
	so ~/.config/nvim/legacy.vim
]])

if vim.fn.exists('g:vscode') == 0 then
	-- Load all plugins when not in vscode
	require('plugins')
	require('lsp')
	require('autocmp')

	vim.keymap.set('n', '<C-p>', ':GFiles<CR>')
	vim.keymap.set('n', '<C-g>', ':Rg<CR>')

	-- vim.cmd("set termguicolors")
	-- vim.cmd("colorscheme tender")
	vim.cmd("autocmd vimenter * ++nested colorscheme gruvbox")

	require('rust-tools').setup({
		tools = {
			autoSetHints = false
		}
	})

	-- nvim-treesitter
	require('nvim-treesitter.configs').setup {
		auto_install = true,
		highlight = {
			enable = true,
		},
	}
end
