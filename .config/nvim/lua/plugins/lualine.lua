return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true },
  config = function()
    local theme_overrides = {
      noir = require 'lualine.themes.noir',
      ['gruvbox-material'] = 'gruvbox-material',
      nordic = 'nordic',
    }
    local theme = theme_overrides[vim.g.colors_name]
      or require 'lualine.themes.auto'

    require('lualine').setup({
      options = {
        section_separators = { left = '', right = '' },
        theme = theme,
      },
      sections = {
        lualine_a = {
          { 'mode', separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = { 'diff', 'diagnostics' },
        lualine_c = { 'filename', 'navic' },
        lualine_x = { 'filetype' },
        lualine_y = {},
        lualine_z = {
          {
            'location',
            separator = { right = '', left = '' },
            left_padding = 2,
          },
        },
      },
      tabline = {
        lualine_c = { 'branch', 'tabs' },
      },
    })
  end,
}
