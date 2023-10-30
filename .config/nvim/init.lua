-- comma as leader
vim.g.mapleader = " "

-- Disable netwr file explorer
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[
	so ~/.config/nvim/legacy.vim
]])

vim.opt.splitbelow = true
vim.opt.splitright = true

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

-- Lsp folding (https://github.com/kevinhwang91/nvim-ufo#quickstart)
-- vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldenable = true

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently
vim.opt.signcolumn = 'yes'

-- Load all plugins when not in vscode
if vim.g.vscode ~= 1 then
	require('plugins')
	require('mylsp')
	require('autocmp')
	require('mydap')
	require("treesitter")


	-- Disable text after line cause we're using lsp_lines
	-- vim.diagnostic.config({
	-- 	virtual_text = false,
	-- })
	
	-- vim.keymap.set('n', '<leader>w', ':w!<CR>')
	vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<CR>')
	vim.keymap.set('x', '<leader>p', '"_dp')
	-- -- Save leader removal
	-- vim.keymap.set('v', '<leader>d', '"0d')
	-- vim.keymap.set('v', '<leader>d', '"0d')
	-- vim.keymap.set('v', '<leader>y', '"0y')
	-- vim.keymap.set('v', '<leader>p', '"0p')

	-- vim.keymap.set('n', 'gs', ':ChatGPT<CR>')

	local telescope = require('telescope.builtin')
	local telescope_actions = require('telescope.actions')
	vim.keymap.set('n', '<C-p>', telescope.find_files)
	vim.keymap.set('n', '<C-g>', telescope.live_grep)
	vim.keymap.set('n', '<C-t>', telescope.buffers)
	vim.keymap.set('n', 'fh', telescope.help_tags)
	vim.keymap.set('n', 'gr', function() telescope.lsp_references({ includeDeclaration = false }) end)
	vim.keymap.set('n', 'gt', telescope.lsp_type_definitions)
	vim.keymap.set('n', 'gd', telescope.lsp_definitions)
	vim.keymap.set('n', 'gi', telescope.lsp_implementations)
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
	vim.cmd("set t_Co=256")
	vim.cmd("set t_ut=")
	vim.cmd("colorscheme codedark")
	-- require('onedark').setup {
	-- 	style = 'warm'
	-- }
	-- require('monokai').setup {}
	-- vim.o.background = 'dark'
	-- require('vscode').setup({})

	-- vim.keymap.set('n', '<C-e>', ':Explore<CR>')
else
	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
end
