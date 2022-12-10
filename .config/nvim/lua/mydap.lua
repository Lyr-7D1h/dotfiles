local dap = require('dap')

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>db', dap.toggle_breakpoint, opts) -- Set breakpoint
vim.keymap.set('n', '<space>ds', dap.continue, opts) -- Launch debug session
vim.keymap.set('n', '<space>do', dap.continue, opts) -- Step over function
vim.keymap.set('n', '<space>di', dap.continue, opts) -- Step into function
vim.keymap.set('n', '<space>dr', dap.continue, opts) -- View state

-- Automatically start up codelldb (https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb))
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = '/usr/bin/codelldb',
    args = {"--port", "${port}"},
  }
}

local dap = require('dap')
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require("dapui").setup()
