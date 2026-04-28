return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
      'yioneko/nvim-vtsls',
    },
    config = function()
      require('vtsls').config({})
      require 'lsp-config'
    end,
  },
  { 'SmiteshP/nvim-navic', dependencies = 'neovim/nvim-lspconfig' },
  { 'dmmulroy/tsc.nvim', version = 'v1.6.0', opts = {} },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
}
