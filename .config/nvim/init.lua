-- comma as leader
vim.g.mapleader = " "

-- Disable netwr file explorer
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[
	so ~/.config/nvim/legacy.vim
]])

if vim.g.vscode ~= 1 then
	-- Load all plugins when not in vscode
	require('plugins')
	require('mylsp')
	require('autocmp')
	require("treesitter")


	-- Disable text after line cause we're using lsp_lines
	-- vim.diagnostic.config({
	-- 	virtual_text = false,
	-- })

	vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<CR>')
	vim.keymap.set('x', '<leader>p', '"_dp')

	local telescope = require('telescope.builtin')
	local telescope_actions = require('telescope.actions')
	vim.keymap.set('n', '<C-p>', telescope.find_files)
	vim.keymap.set('n', '<C-g>', telescope.live_grep)
	vim.keymap.set('n', '<C-t>', telescope.buffers)
	vim.keymap.set('n', 'fh', telescope.help_tags)
	vim.keymap.set('n', 'gr', telescope.lsp_references)
	require("telescope").setup({
		defaults = {
			mappings = {
				i = {
					["<esc>"] = telescope_actions.close,
					["<C-u>"] = false
				}
			}
		}
	})


	-- fzf
	-- vim.keymap.set('n', '<C-p>', ':Files<CR>')
	-- vim.keymap.set('n', '<C-g>', ':Rg<CR>')
	-- vim.keymap.set('n', '<C-t>', ':Buffers<CR>')

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

	-- vim.keymap.set('n', '<C-e>', ':Explore<CR>')


	require "fidget".setup {}
end
