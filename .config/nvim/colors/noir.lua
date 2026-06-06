local palette = {
  accent = '#9BBEFF',
  bg = '#1B1F22',
  bg_alt = '#23292D',
  fg = '#DFDFE0',
  fg_dim = '#B4BBC8',
  comment = '#7C8395',
  border = '#333C40',

  constant = '#B7D3FF',
  directory = '#9ECFA5',
  keyword = '#A6D6A6',

  visual_bg = '#2A3236',
  pmenu_sel_bg = '#2E3B4A',
  picker_sel_bg = '#3A464C',

  git_add_fg = '#9ED4B0',
  git_del_fg = '#D28A8A',

  diff_add_bg = '#0F2118',
  diff_change_bg = '#0F2136',
  diff_del_bg = '#2A1517',
  diff_text_bg = '#1A3355',
  inline_add_bg = '#143028',
  inline_change_bg = '#142C44',
  inline_del_bg = '#301A1E',

  diag_error_fg = '#E0908F',
  diag_warn_fg = '#D9C08C',
  diag_hint_fg = '#9BCEB5',
  diag_error_sp = 'NvimLightRed',
  diag_warn_sp = 'NvimLightYellow',

  search_bg = '#34405A',
  search_cur_bg = '#4A5B82',
  match_paren_bg = '#3D4A52',

  nontext = '#3F484E',
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
hi('Visual', { bg = palette.visual_bg })
hi('Directory', { fg = palette.directory })

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
hi('Constant', { fg = palette.constant })
hi('Special', { fg = palette.accent })

hi('StatusLine', { fg = palette.fg, bg = palette.bg_alt })
hi('StatusLineNC', { fg = palette.comment, bg = palette.bg })

hi('PmenuSel', {
  bg = palette.pmenu_sel_bg,
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
hi('GitSignsDeleteLn', { bg = palette.diff_del_bg })
hi('GitSignsDeleteInline', { bg = palette.diff_del_bg })

hi('DiffAdd', { bg = palette.diff_add_bg })
hi('DiffChange', { bg = palette.diff_change_bg })
hi('DiffDelete', { bg = palette.diff_del_bg })
hi('DiffText', { bg = palette.diff_text_bg, bold = true })
hi('DiffAdded', { bg = palette.inline_add_bg })
hi('DiffChanged', { bg = palette.inline_change_bg })
hi('DiffRemoved', { bg = palette.inline_del_bg })

hi('DiagnosticError', { fg = palette.diag_error_fg })
hi('DiagnosticWarn', { fg = palette.diag_warn_fg })
hi('DiagnosticInfo', { fg = palette.accent })
hi('DiagnosticHint', { fg = palette.diag_hint_fg })
hi('MoreMsg', { fg = palette.keyword })

hi(
  'DiagnosticUnderlineError',
  { fg = 'NONE', bg = 'NONE', sp = palette.diag_error_sp, undercurl = true }
)
hi(
  'DiagnosticUnderlineWarn',
  { fg = 'NONE', bg = 'NONE', sp = palette.diag_warn_sp, undercurl = true }
)
hi(
  'DiagnosticUnderlineInfo',
  { fg = 'NONE', bg = 'NONE', sp = palette.accent, undercurl = true }
)
hi(
  'DiagnosticUnderlineHint',
  { fg = 'NONE', bg = 'NONE', sp = palette.diag_hint_fg, undercurl = true }
)
hi('FlashLabel', { fg = palette.keyword })

-- Search / matching
hi('Search', { fg = palette.fg, bg = palette.search_bg })
hi('IncSearch', { fg = palette.fg, bg = palette.search_cur_bg, bold = true })
hi('CurSearch', { fg = palette.fg, bg = palette.search_cur_bg, bold = true })
hi('MatchParen', { bg = palette.match_paren_bg, bold = true })

-- Gutter / chrome
hi('SignColumn', { bg = 'NONE' })
hi('FoldColumn', { fg = palette.comment, bg = 'NONE' })
hi('Folded', { fg = palette.comment, bg = palette.bg_alt })
hi('ColorColumn', { bg = palette.bg_alt })
hi('EndOfBuffer', { fg = palette.nontext })
hi('NonText', { fg = palette.nontext })
hi('Whitespace', { fg = palette.nontext })
hi('Cursor', { fg = palette.bg, bg = palette.fg })
hi('QuickFixLine', { bg = palette.bg_alt, bold = true })

-- Titles / messages / tabs
hi('Title', { fg = palette.accent, bold = true })
hi('ErrorMsg', { fg = palette.diag_error_fg })
hi('WarningMsg', { fg = palette.diag_warn_fg })
hi('TabLineFill', { bg = palette.bg })
hi('TabLine', { fg = palette.comment, bg = palette.bg_alt })
hi('TabLineSel', { fg = palette.fg, bg = palette.bg, bold = true })
hi('WinBar', { fg = palette.fg, bg = palette.bg })
hi('WinBarNC', { fg = palette.comment, bg = palette.bg })

-- Floats / popups
hi('NormalFloat', { fg = palette.fg, bg = palette.bg_alt })
hi('FloatBorder', { fg = palette.border, bg = palette.bg_alt })
hi('FloatTitle', { fg = palette.accent, bg = palette.bg_alt })
hi('Pmenu', { fg = palette.fg, bg = palette.bg_alt })
hi('PmenuSbar', { bg = palette.bg_alt })
hi('PmenuThumb', { bg = palette.border })

-- Snacks picker
hi('SnacksNormal', { link = 'NormalFloat' })
hi('SnacksNormalNC', { link = 'NormalFloat' })
hi('SnacksWinBar', { link = 'FloatTitle' })
hi('SnacksWinBarNC', { link = 'NormalFloat' })
hi('SnacksPicker', { link = 'NormalFloat' })
hi('SnacksPickerBorder', { link = 'FloatBorder' })
hi('SnacksPickerTitle', { link = 'FloatTitle' })
hi('SnacksPickerList', { link = 'NormalFloat' })
hi('SnacksPickerPreview', { link = 'NormalFloat' })
hi('SnacksPickerInput', { fg = palette.fg, bg = palette.bg_alt })
hi('SnacksPickerInputBorder', { link = 'FloatBorder' })
hi('SnacksPickerListCursorLine', { bg = palette.picker_sel_bg })
hi('SnacksPickerMatch', { fg = palette.accent, bold = true })
hi('SnacksPickerDir', { fg = palette.comment })
