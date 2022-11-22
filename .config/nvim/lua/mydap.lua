local dap = require('dap')

-- dap.adapters.rust = {
--   type = 'executable';
--   command = os.getenv('HOME') .. '/.virtualenvs/tools/bin/python';
--   args = { '-m', 'debugpy.adapter' };
-- }

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>db', dap.toggle_breakpoint, opts) -- Set breakpoint
vim.keymap.set('n', '<space>ds', dap.continue, opts) -- Launch debug session
vim.keymap.set('n', '<space>do', dap.continue, opts) -- Step over function
vim.keymap.set('n', '<space>di', dap.continue, opts) -- Step into function
vim.keymap.set('n', '<space>dr', dap.continue, opts) -- View state
