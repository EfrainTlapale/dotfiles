return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
  },
  {
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ---@module 'treesitter-modules'
    ---@type ts.mod.UserConfig
    opts = {
      ensure_installed = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'typescript',
        'css',
        'scss',
        'javascript',
        'markdown',
        'markdown_inline',
        'python',
        'tsx',
        'bash',
        'fish',
        'json',
        'http',
        'yaml',
        'latex',
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-s>',
          node_incremental = '<C-s>',
          node_decremental = '<C-h>',
        },
      },
    },
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('ts_context_commentstring').setup({ enable_autocmd = false })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    opts = { auto_close_on_slash = true },
  },
}
