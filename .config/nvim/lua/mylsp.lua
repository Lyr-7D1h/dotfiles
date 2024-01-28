require("nvim-lsp-installer").setup {
  automatic_installation = true
}

-- Auto format before write
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]


local lspconfig = require("lspconfig")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local function has_value(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

local format_on_save_servers = { "rust_analyzer", "null-ls", "tsserver" }
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- If formatting is supported and it is one of the known servers add format on save
  if client.server_capabilities.documentFormattingProvider and has_value(format_on_save_servers, client.name) then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.format { async = true }]]
    vim.api.nvim_command [[augroup END]]
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  -- Replaced with telescope
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)

  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- Add additional capabilities supported by nvim-cmp
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').cmp_nvim_lsp.default_capabilities(capabilities)
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Lsp based folding
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- sets up rust_analyzer lsp server
require('rust-tools').setup({
  tools = {
    autoSetHints = false
  },
  server = {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          disabled = { "unresolved-proc-macro" } -- Prevent random error messages for proc macro's
        }
      }
    }
  },
  -- dap = {
  --   adapter = require('dap').adapters.lldb
  -- },
  dap = {
    adapter = {
      type = "executable",
      command = "lldb-vscode",
      name = "rt_lldb",
    }
  }
})

-- Setup up python
-- https://github.com/mattn/efm-langserver
lspconfig.efm.setup {
  filetypes = { "python", "css", "scss", "less" }, -- See `:Filetypes`
  -- filetypes = { "python", "javascript", "typescript", "javascriptreact", "javascript.jsx", "typescript",
  --   "typescriptreact", "typescript.tsx" }, -- See `:Filetypes`

  -- Allows for pyproject usage
  root_dir = function()
    return vim.fs.dirname(vim.fs.find({ '.git', 'pyproject.toml' }, { upward = true })[1])
  end,

  init_options = { documentFormatting = true },
  settings = {
    rootMarkers = { ".git/", "pyproject.toml" },
    languages = {
      python = {
        { formatCommand = "black --quiet -", formatStdin = true },
        { formatCommand = "isort --quiet -", formatStdin = true },
        {
          lintCommand = "mypy --show-column-numbers --ignore-missing-imports --show-error-codes",
          lintIgnoreExitCode = true,
          lintFormats = {
            '%f:%l:%c: %trror: %m',
            '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m'
          },
          lintSource = "mypy",
        },
        {
          lintCommand = "pylint --output-format text --score no --msg-template {path}:{line}:{column}:{C}:{msg} ${INPUT}",
          lintStdin = false,
          lintOffsetColumns = 1,
          lintIgnoreExitCode = true,
          lintCategoryMap = {
            I = "H",
            R = "I",
            C = "I",
            W = "W",
            E = "E",
            F = "E"
          },
          lintFormats = { "%f:%l:%c:%t:%m" }

        }
      },
      css = { { formatCommand = 'prettier --stdin-filepath ${INPUT}', formatStdin = true } },
      scss = { { formatCommand = 'prettier --stdin-filepath ${INPUT}', formatStdin = true } },
      less = { { formatCommand = 'prettier --stdin-filepath ${INPUT}', formatStdin = true } },
      -- typescript = {
      --   formatCommand = "node_modules/.bin/prettier --stdin-filepath" .. vim.api.nvim_buf_get_name(0),
      --   formatStdin = true
      -- }
    }
  }
}
lspconfig.ltex.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  settings =
  {
    ltex = {
      language = "en-GB",
    },
  }
}

-- Setup prettier
-- local null_ls = require("null-ls")
-- null_ls.setup({
--   on_attach = on_attach
-- })
-- local prettier = require("prettier")
-- prettier.setup({
--   bin = 'prettierd',
--   filetypes = {
--     "css",
--     "graphql",
--     "html",
--     "javascript",
--     "javascriptreact",
--     "json",
--     "less",
--     "markdown",
--     "scss",
--     "typescript",
--     "typescriptreact",
--     "yaml",
--   },
-- })

-- lspconfig["pylsp"].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   plugins = {
--     black = {
--       enabled = true
--     },
--     mypy = {
--       enabled = true,
--       live_mode = true,
--       strict = true
--     },
--     isort = {
--       enabled = true
--     }
--   }
-- }

require("typescript").setup({
  disable_commands = false,   -- prevent the plugin from creating Vim commands
  debug = false,              -- enable debug logging for commands
  go_to_source_definition = {
    fallback = true,          -- fall back to standard LSP definition on failure
  },
  server = {                  -- pass options to lspconfig's setup method
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  },
})

-- LSP Servers: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Basic setup
local servers = { 'pyright', 'luau_lsp', 'eslint', 'ccls', "taplo", "bashls", "cssls", "jsonls", "html", "lua_ls",
  "julials", "terraformls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      if client.name == "tsserver" then -- disable formatting for tsserver
        client.server_capabilities.document_formatting = false
      end

      on_attach(client, bufnr)
    end,
    flags = lsp_flags,
    capabilities = capabilities,
  }
end
