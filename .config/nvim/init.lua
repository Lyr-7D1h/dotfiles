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

if vim.g.vscode then
	-- VSCODE
	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
	vim.keymap.set('n', '<C-w>a', function()
		vim.cmd("call VSCodeNotify('workbench.action.closeOtherEditors')")
	end)
	vim.keymap.set('n', 'gt', function()
		vim.cmd("call VSCodeNotify('editor.action.goToTypeDefinition')")
	end)
	vim.keymap.set('n', 'gr', function()
		vim.cmd("call VSCodeNotify('editor.action.goToReferences')")
	end)
	vim.keymap.set('n', 'gD', function()
		vim.cmd("call VSCodeNotify('editor.action.revealDeclaration')")
	end)

	-- add folding
	vim.cmd [[
	nnoremap zM :call VSCodeNotify('editor.foldAll')<CR>
	nnoremap zR :call VSCodeNotify('editor.unfoldAll')<CR>
	nnoremap zc :call VSCodeNotify('editor.fold')<CR>
	nnoremap zC :call VSCodeNotify('editor.foldRecursively')<CR>
	nnoremap zo :call VSCodeNotify('editor.unfold')<CR>
	nnoremap zO :call VSCodeNotify('editor.unfoldRecursively')<CR>
	nnoremap za :call VSCodeNotify('editor.toggleFold')<CR>
	
	" function! MoveCursor(direction) abort
	" 	if(reg_recording() == '' && reg_executing() == '')
	" 		return 'g'.a:direction
	" 	else
	" 		return a:direction
	" 	endif
	" endfunction
	"
	" nmap <expr> j MoveCursor('j')
	" nmap <expr> k MoveCursor('k')
	]]
else
	-- Load all plugins when not in vscode
	require('plugins')
	require('mylsp')
	require('autocmp')
	-- require('mydap')
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
	-- vim.keymap.set('n', '<C-p>', telescope.find_files)
	vim.api.nvim_set_keymap('n', '<C-p>', "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob=!.git/<CR>", { noremap = true, silent = true })
	vim.keymap.set('n', '<C-g>', telescope.live_grep)
	vim.keymap.set('n', '<C-t>', telescope.buffers)
	vim.keymap.set('n', 'fh', telescope.help_tags)
	vim.keymap.set('n', 'gr', function() telescope.lsp_references({ include_declaration = false }) end)
	vim.keymap.set('n', 'gt', telescope.lsp_type_definitions)
	vim.keymap.set('n', 'gd', telescope.lsp_definitions)
	vim.keymap.set('n', 'gi', telescope.lsp_implementations)
	require('telescope').setup({
		defaults = {
			mappings = {
				i = {
					["<esc>"] = telescope_actions.close,
					["<C-u>"] = false
				}
			}
		},
	})

	vim.keymap.set('n', '^^N', ':bnext<CR>')
	vim.keymap.set('n', '^^p', ':bprevious<CR>')

	-- HARPOON
	-- local harpoon = require('harpoon')
	-- harpoon:setup({})
	-- local conf = require("telescope.config").values
	-- local function toggle_telescope(harpoon_files)
	-- 	local file_paths = {}
	-- 	for _, item in ipairs(harpoon_files.items) do
	-- 		table.insert(file_paths, item.value)
	-- 	end
	--
	-- 	require("telescope.pickers").new({}, {
	-- 		prompt_title = "Harpoon",
	-- 		finder = require("telescope.finders").new_table({
	-- 			results = file_paths,
	-- 		}),
	-- 		previewer = conf.file_previewer({}),
	-- 		sorter = conf.generic_sorter({}),
	-- 	}):find()
	-- end
	-- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
	-- 	{ desc = "Open harpoon window" })
	-- vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
	-- -- Toggle previous & next buffers stored within Harpoon list
	-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
	-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
	-- -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
	-- -- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
	-- -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
	-- -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)


	-- fzf
	-- vim.keymap.set('n', '<C-p>', ':Files<CR>')
	-- vim.keymap.set('n', '<C-g>', ':Rg<CR>')
	-- vim.keymap.set('n', '<C-t>', ':Buffers<CR>')

	-- This unsets the "last search pattern" register by hitting escape
	vim.keymap.set('n', '<esc>', ':noh<CR><esc>')
	vim.keymap.set('n', '<esc>^[', '<esc>^[')

	vim.keymap.set('n', '<leader>b', ':ToggleBlameLine<CR>')

	-- Remove all buffers not in a window
	vim.keymap.set('n', '<C-w>a', function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) then
				if vim.fn.buflisted(buf) == 1 and vim.fn.bufwinnr(buf) == -1 then
					vim.api.nvim_command('bdelete ' .. buf)
				end
			end
		end
		-- vim.cmd("call VSCodeNotify(':bufdo if buflisted() && bufwinnr('%') == -1 | bd | endif')")
	end)


	-- Theming
	-- vim.cmd("set termguicolors")
	-- vim.cmd("colorscheme tender")
	-- vim.cmd("colorscheme catppuccin")
	-- vim.cmd("autocmd vimenter * ++nested colorscheme gruvbox")
	-- require('vscodetheme').setup({
	--     style = 'light'
	-- })
	-- vim.cmd("set t_Co=256")
	-- vim.cmd("set t_ut=")
	-- vim.cmd("colorscheme codedark")
	-- vim.o.background = "light" -- or "light" for light mode
	-- vim.cmd([[colorscheme gruvbox]])
	-- require('onedark').setup {
	-- 	style = 'warm'
	-- }
	-- require('monokai').setup {}
	-- vim.o.background = 'dark'

	-- vim.keymap.set('n', '<C-e>', ':Explore<CR>')
end
