-- local palette = {
--   accent = '#7F9FBF',
--   bg = '#08090B',
--   bg_alt = '#0E1014',
--   fg = '#D6DAE0',
--   fg_dim = '#A3A8B1',
--   comment = '#6B7280',
--   border = '#1B1F27',
--
--   git_add_fg = '#7F9F88',
--   git_del_fg = '#9A6B6B',
--
--   diff_add_bg = '#13201A',
--   diff_change_bg = '#132029',
--   diff_del_bg = '#241618',
--   diff_text_bg = '#1B2A36',
--   inline_add_bg = '#1A2A22',
--   inline_change_bg = '#1A2632',
--   inline_del_bg = '#2A1A1D',
--   keyword = '#8FAF8F',
-- }

-- DEEPER
-- local palette = {
--   accent = '#8FB3D9',
--   bg = '#050608',
--   bg_alt = '#0A0C10',
--   fg = '#E1E5EB',
--   fg_dim = '#A9AFB9',
--   comment = '#6E7582',
--   border = '#141821',
--
--   git_add_fg = '#8FBFA0',
--   git_del_fg = '#B07C7C',
--
--   diff_add_bg = '#0F1C16',
--   diff_change_bg = '#0F1C2A',
--   diff_del_bg = '#1E1113',
--   diff_text_bg = '#162635',
--   inline_add_bg = '#13261C',
--   inline_change_bg = '#132030',
--   inline_del_bg = '#261418',
--   keyword = '#9BC89B',
-- }

-- SOFT
-- local palette = {
--   accent = '#7A9EC2',
--   bg = '#0D0F14',
--   bg_alt = '#141821',
--   fg = '#D1D6DE',
--   fg_dim = '#9CA2AE',
--   comment = '#7A8090',
--   border = '#232838',
--
--   git_add_fg = '#86B39A',
--   git_del_fg = '#A67A7A',
--
--   diff_add_bg = '#18261F',
--   diff_change_bg = '#18263A',
--   diff_del_bg = '#2A1A1D',
--   diff_text_bg = '#1E3144',
--   inline_add_bg = '#1C3026',
--   inline_change_bg = '#1C2D3E',
--   inline_del_bg = '#301D21',
--   keyword = '#93B993',
-- }

-- more contrast
local palette = {
  accent = '#9BBEFF',
  bg = '#06070A',
  bg_alt = '#0C0E14',
  fg = '#F0F3FA',
  fg_dim = '#B4BBC8',
  comment = '#7C8395',
  border = '#161A26',

  git_add_fg = '#9ED4B0',
  git_del_fg = '#D28A8A',

  diff_add_bg = '#0F2118',
  diff_change_bg = '#0F2136',
  diff_del_bg = '#2A1517',
  diff_text_bg = '#1A3355',
  inline_add_bg = '#143028',
  inline_change_bg = '#142C44',
  inline_del_bg = '#301A1E',
  keyword = '#A6D6A6',
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

vim.cmd 'highlight clear'
vim.cmd 'syntax reset'

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.g.colors_name = 'noir'

hi('Normal', { fg = palette.fg, bg = palette.bg })
hi('CursorLine', { bg = palette.bg_alt })
hi('Visual', { bg = '#222735' })
hi('Directory', { fg = '#9ECFA5' })

hi('LineNr', { fg = palette.comment })
hi('CursorLineNr', { fg = palette.accent })
hi('VertSplit', { fg = palette.border, bg = palette.bg })
hi('WinSeparator', { fg = palette.border, bg = palette.bg })

hi('Comment', { fg = palette.comment, italic = true })
hi('String', { fg = palette.fg })
hi('Function', { fg = palette.accent })
hi('Keyword', { fg = palette.keyword })
hi('Type', { fg = palette.accent })
hi('Identifier', { fg = palette.fg_dim })
hi('Operator', { fg = palette.fg })
hi('Constant', { fg = '#B7D3FF' })
hi('Special', { fg = palette.accent })

hi('StatusLine', { fg = palette.fg, bg = palette.bg_alt })
hi('StatusLineNC', { fg = palette.comment, bg = palette.bg })

hi('PmenuSel', {
  bg = '#1B2A4A',
  fg = palette.fg,
  bold = true,
})

hi('@function', { fg = palette.accent })
hi('@keyword', { fg = palette.keyword })
hi('@type', { fg = palette.accent })
hi('@comment', { fg = palette.comment, italic = true })

hi('@tag', { fg = palette.accent })
hi('@tag.delimiter', { fg = palette.fg_dim })
hi('@tag.tsx', { fg = palette.accent })
hi('@constructor.tsx', { fg = palette.accent })

hi('@tag.attribute', { fg = palette.fg_dim })
hi('@variable.jsx', { fg = palette.fg })
hi('@string.jsx', { fg = palette.fg })
hi('@text.jsx', { fg = palette.fg })
hi('@text.jsx', { fg = palette.fg })

hi('@punctuation.bracket', { fg = palette.fg_dim })
hi('@punctuation.delimiter', { fg = palette.fg_dim })
hi('@boolean.jsx', { fg = palette.fg_dim })

hi('GitSignsAdd', { fg = palette.git_add_fg })
hi('GitSignsChange', { fg = palette.accent })
hi('GitSignsDelete', { fg = palette.git_del_fg })

hi('GitSignsAddNr', { fg = palette.git_add_fg })
hi('GitSignsChangeNr', { fg = palette.accent })
hi('GitSignsDeleteNr', { fg = palette.git_del_fg })

hi('GitSignsAddLn', { bg = palette.diff_add_bg })
hi('GitSignsAddInline', { bg = palette.diff_add_bg })
hi('GitSignsChangeLn', { bg = palette.diff_change_bg })
hi('GitSignsChangeInline', { bg = palette.diff_change_bg })
hi('GitSignsDeleteLn', { bg = palette.diff_text_bg })
hi('GitSignsDeleteInline', { bg = palette.diff_del_bg })

hi('DiffAdd', { bg = palette.diff_add_bg })
hi('DiffChange', { bg = palette.diff_change_bg })
hi('DiffDelete', { bg = palette.diff_del_bg })
hi('DiffText', { bg = palette.diff_text_bg, bold = true })
hi('DiffAdded', { bg = palette.inline_add_bg })
hi('DiffChanged', { bg = palette.inline_change_bg })
hi('DiffRemoved', { bg = palette.inline_del_bg })

hi('DiagnosticInfo', { fg = palette.accent })
hi('MoreMsg', { fg = palette.keyword })

hi(
  'DiagnosticUnderlineError',
  { fg = 'NONE', bg = 'NONE', sp = 'NvimLightRed', undercurl = true }
)
hi(
  'DiagnosticUnderlineWarn',
  { fg = 'NONE', bg = 'NONE', sp = 'NvimLightYellow', undercurl = true }
)
hi('FlashLabel', { fg = palette.keyword })
