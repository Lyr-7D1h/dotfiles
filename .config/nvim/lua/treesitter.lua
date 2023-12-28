vim.cmd('au BufRead,BufNewFile *.wgsl	set filetype=wgsl')

-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.wgsl = {
--   install_info = {
--     url = "https://github.com/szebniok/tree-sitter-wgsl",
--     files = { "src/parser.c" }
--   },
-- }

-- Default comment string
vim.bo.commentstring = '//%s'

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'comment' },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  ident = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

require 'treesitter-context'.setup {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      'class',
      'function',
      'method',
      -- 'for', -- These won't appear in the context
      -- 'while',
      -- 'if',
      -- 'switch',
      -- 'case',
    },
    -- Example for a specific filetype.
    -- If a pattern is missing, *open a PR* so everyone can benefit.
    --   rust = {
    --       'impl_item',
    --   },
  },
  exact_patterns = {
    -- Example for a specific filetype with Lua patterns
    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
    -- exactly match "impl_item" only)
    -- rust = true,
  },

  -- [!] The options below are exposed but shouldn't require your attention,
  --     you can safely ignore them.

  zindex = 20, -- The Z-index of the context window
  mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
  separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
}

require 'nvim-web-devicons'.setup {}
require("nvim-tree").setup({
  view = {
    mappings = {
      list = {
        -- https://github.com/kyazdani42/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt#L1248
        -- { key = "u", action = "dir_up" },
        { key = "<C-e>", action = "" },
        { key = "<F2>", action = "rename" }
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
  },
})
vim.keymap.set('n', '<C-e>', ':NvimTreeToggle<CR>')
