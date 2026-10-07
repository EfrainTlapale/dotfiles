return {
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
  {
    'dtormoen/neural-open.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    -- NeuralOpen implements lazy loading internally. It needs to be loaded for recency tracking to work.
    lazy = false,
    keys = {
      { '<leader><leader>', '<Plug>(NeuralOpen)', desc = 'Neural Open Files' },
    },
    -- opts are optional. NeuralOpen will automatically use the defaults below.
    opts = {},
  },
  {
    'kawre/leetcode.nvim',
    build = ':TSUpdate html', -- if you have `nvim-treesitter` installed
    dependencies = {
      -- include a picker of your choice, see picker section for more details
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lang = 'typescript',
      picker = 'snacks-picker',
    },
    {
      '2giosangmitom/sqmeow.nvim',
      dependencies = { 'MunifTanjim/nui.nvim' },
      version = '*',
      build = function()
        -- Downloads the matching release binary; pass 'curl', 'wget', 'powershell' or 'cargo' to choose.
        require('sqmeow').install()
      end,
      opts = {},
      cmd = 'Sqmeow',
      keys = {
        { '<leader>st', '<cmd>Sqmeow toggle<cr>', desc = 'Toggle' },
      },
    },
  },
}
