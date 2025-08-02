vim.opt.background = "dark" -- set this to dark or light

-- vim.cmd.colorscheme "oxocarbon"
-- vim.cmd.colorscheme "catppuccin-macchiato"
vim.cmd.colorscheme "carbonfox"
-- vim.cmd.colorscheme "everforest"
-- vim.cmd.colorscheme "shadow"

require('kanso').setup({
  theme = 'mist',
  background = { dark = 'mist' },
  colors = {
    theme = {
      mist = {
        syn = {
          constant = "none"
        }
      }
    }
  }
})

-- vim.cmd.colorscheme "kanso"
