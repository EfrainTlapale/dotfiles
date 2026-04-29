return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    -- NOTE: The log_level is in `opts.opts`
    opts = {},
    interactions = {
      cli = {
        agent = 'claude_code',
        agents = {
          claude_code = {
            cmd = 'claude',
            args = {},
            description = 'Claude Code CLI',
            provider = 'terminal',
          },
        },
      },
    },
  },
}
