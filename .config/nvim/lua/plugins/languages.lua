return {
  {
    'mistweaverco/kulala.nvim',
    opts = {},
    ft = { 'http', 'rest' },
    keys = {
      { '<CR>', "<cmd>lua require('kulala').run()<CR>", ft = 'http' },
      { '[r', "<cmd>lua require('kulala').jump_prev()<CR>", ft = 'http' },
      { ']r', "<cmd>lua require('kulala').jump_next()<CR>", ft = 'http' },
      {
        '<leader>ci',
        "<cmd>lua require('kulala').from_curl()<CR>",
        ft = 'http',
      },
      {
        '<leader>co',
        "<cmd>lua require('kulala').copy()<CR>",
        ft = 'http',
      },
      {
        '<leader>o',
        "<cmd>lua require('kulala').search()<CR>",
        ft = 'http',
      },
      {
        '<leader>ck',
        "<cmd>lua require('kulala').close()<CR>",
        ft = 'http',
      },
    },
  },
  {
    'S1M0N38/love2d.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        '<leader>vv',
        '<cmd>LoveRun<cr>',
        ft = 'lua',
        desc = 'Run LÖVE',
      },
      {
        '<leader>vs',
        '<cmd>LoveStop<cr>',
        ft = 'lua',
        desc = 'Stop LÖVE',
      },
    },
  },
}
