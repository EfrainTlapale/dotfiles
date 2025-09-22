vim.opt.background = "dark" -- set this to dark or light

-- vim.cmd.colorscheme "oxocarbon"
-- vim.cmd.colorscheme "catppuccin-macchiato"
-- vim.cmd.colorscheme "carbonfox"
-- vim.cmd.colorscheme "nordfox"
-- vim.cmd.colorscheme "rusty"
-- vim.cmd.colorscheme "shadow"

-- allows custom theme to be loaded from this config
-- vim.opt.runtimepath:append("~/.config/nvim/lua")
-- vim.cmd.colorscheme "efra"

vim.cmd.colorscheme "everforest"
vim.api.nvim_set_hl(0, 'NonText', { fg = '#859289' })

-- require('kanso').setup({
--   theme = 'mist',
--   background = { dark = 'mist' },
--   colors = {
--     palette = {
--       red = '#FF9E99',
--       gitRed = '#FF9E99',
--       -- diffRed = '#FF9E99',
--       diffRed = 'NONE',
--       -- diffRed = { bg = '#FF9E99' }
--       -- diffRed = '#FAA0A0'
--     },
--     theme = {
--       mist = {
--         syn = {
--           constant = "none"
--         },
--       }
--     }
--   }
-- })
--
-- vim.cmd.colorscheme "kanso"

-- vim.cmd("colorscheme monokai-v2")
-- vim.api.nvim_set_hl(0, 'string', { fg = '#FFEE8C' })
-- vim.api.nvim_set_hl(0, '@string', { fg = '#FFEE8C' })

-- vim.cmd.colorscheme "oldworld"
-- vim.cmd.colorscheme("lackluster-hack")
-- vim.cmd.colorscheme "no-clown-fiesta"
