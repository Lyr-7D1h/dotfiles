-- comma as leader
vim.g.mapleader = " "

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

	local telescope = require('telescope.builtin')
	local telescope_actions = require('telescope.actions')
	vim.keymap.set('n', 'ff', telescope.find_files)
	vim.keymap.set('n', 'fg', telescope.live_grep)
	vim.keymap.set('n', 'fb', telescope.buffers)
	vim.keymap.set('n', 'fh', telescope.help_tags)
	require("telescope").setup({
		defaults = {
			mappings = {
				i = {
					["<esc>"] = telescope_actions.close
				}
			}
		}
	})


	vim.keymap.set('n', '<C-p>', ':Files<CR>')
	vim.keymap.set('n', '<C-g>', ':Rg<CR>')
	vim.keymap.set('n', '<C-t>', ':Buffers<CR>')
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
end
