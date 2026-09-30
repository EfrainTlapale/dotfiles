return {
  {
    'EfrainTlapale/req.nvim',
    opts = {
      format_on_save = true,
    },
    ft = { 'http' },
    init = function()
      vim.filetype.add({ extension = { rest = 'http' } })
    end,
    keys = {
      { '<CR>', "<cmd>lua require('req').run()<CR>", ft = 'http' },
      { '[r', "<cmd>lua require('req').jump_prev()<CR>", ft = 'http' },
      { ']r', "<cmd>lua require('req').jump_next()<CR>", ft = 'http' },
      { '<leader>ci', "<cmd>lua require('req').from_curl()<CR>", ft = 'http' },
      { '<leader>co', "<cmd>lua require('req').copy()<CR>", ft = 'http' },
      { '<leader>o', "<cmd>lua require('req').search()<CR>", ft = 'http' },
      { '<leader>ck', "<cmd>lua require('req').close()<CR>", ft = 'http' },
      { '<leader>ce', "<cmd>lua require('req').set_env()<CR>", ft = 'http' },
    },
  },
  -- {
  --   'S1M0N38/love2d.nvim',
  --   event = 'VeryLazy',
  --   opts = {},
  --   keys = {
  --     {
  --       '<leader>vv',
  --       '<cmd>LoveRun<cr>',
  --       ft = 'lua',
  --       desc = 'Run LÖVE',
  --     },
  --     {
  --       '<leader>vs',
  --       '<cmd>LoveStop<cr>',
  --       ft = 'lua',
  --       desc = 'Stop LÖVE',
  --     },
  --   },
  -- },
}
