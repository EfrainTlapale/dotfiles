return {
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    config = function()
      require('luasnip.loaders.from_lua').load({ paths = './snippets' })
      local ls = require 'luasnip'
      ls.filetype_extend('typescript', { 'javascript' })
      ls.filetype_extend('typescriptreact', { 'javascript' })
    end,
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      enabled = function()
        if vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.bo.filetype) then
          return false
        end

        local row, column = unpack(vim.api.nvim_win_get_cursor(0))
        local success, node = pcall(vim.treesitter.get_node, {
          bufnr = 0,
          pos = { row - 1, math.max(0, column - 1) }, -- seems to be necessary...
        })
        if
          success
          and node
          and vim.tbl_contains(
            { 'comment', 'line_comment', 'block_comment' },
            node:type()
          )
        then
          return false
        end

        return vim.bo.buftype ~= 'nofile'
      end,
      keymap = {
        preset = 'none',
        ['<C-space>'] = {
          'show',
          'show_documentation',
          'hide_documentation',
        },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = {
          'select_next',
          'snippet_forward',
          'fallback',
        },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = {
          auto_show = false,
        },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
      },
      sources = {
        default = { 'lsp' },
      },
      snippets = { preset = 'luasnip' },
      signature = {
        enabled = true,
        trigger = { enabled = false },
        window = {
          winblend = 10,
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      cmdline = {
        enabled = true,
        completion = {
          ghost_text = { enabled = false },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
