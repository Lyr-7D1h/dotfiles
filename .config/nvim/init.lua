-- comma as leader
vim.g.mapleader = " "

vim.cmd([[
	so ~/.config/nvim/legacy.vim
]])

if vim.fn.exists('g:vscode') == 0 then
	-- Load all plugins when not in vscode
	require('plugins')

	require('lsp')

	-- nvim-treesitter
	require('nvim-treesitter.configs').setup {
		auto_install = true,
	    highlight = {
		enable = true,
	    },
	}
end
