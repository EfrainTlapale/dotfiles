return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'medium'
    end,
  },
  {
    'neanias/everforest-nvim',
    lazy = true,
    config = function()
      require('everforest').setup({
        background = 'hard',
        disable_italic_comments = true,
        on_highlights = function(hl, palette)
          hl.NonText = { fg = '#859289' }
        end,
      })
    end,
  },
  { 'EdenEast/nightfox.nvim', lazy = true },
  { 'vague-theme/vague.nvim', lazy = true, opts = { bold = false } },
  { 'AlexvZyl/nordic.nvim', lazy = true },
  { 'webhooked/kanso.nvim', lazy = true },
  {
    'AvengeMedia/base46',
    lazy = true,
    opts = {},
  },
}
