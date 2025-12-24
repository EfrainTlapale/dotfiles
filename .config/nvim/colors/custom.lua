vim.cmd 'highlight clear'
vim.cmd 'syntax reset'

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.g.colors_name = 'custom'

local p = {
  bg = '#09090C',
  bg_alt = '#13131A',
  bg_float = '#16161E',
  fg = '#DADFE6',

  blue = '#7AA2F7',
  blue_bright = '#8FB6FF',
  purple = '#9F8AD7',
  purple_soft = '#8B7EC8',
  -- cyan = '#7DCFFF',
  -- cyan_soft  = '#6FB8D6'  -- slightly grayer, very safe
  cyan = '#6AAFC7', -- more zen, less neon
  -- cyan_soft3 = '#5FA3BB'  -- noticeably calmer, still readable

  -- green = '#9ECE6A',
  --   green_soft  = '#8FBF6A'  -- tiny step down, barely noticeable
  green = '#87B96B', -- balanced, less yellow
  -- green_soft3 = '#7FAF66'  -- more zen, less contrast

  yellow = '#E0AF68',
  red = '#F7768E',

  comment = '#5C6370',
  gray = '#3B3F4C',
  border = '#2A2E3A',
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hi('Normal', { fg = p.fg, bg = p.bg })
hi('CursorLine', { bg = p.bg_alt })
hi('Visual', { bg = '#232631' })
hi('LineNr', { fg = p.gray })
hi('CursorLineNr', { fg = p.blue, bold = true })
hi('Comment', { fg = p.comment, italic = true })

hi('Function', { fg = p.blue_bright })
-- hi('Identifier', { fg = p.fg })
-- hi('Identifier', { fg = '#C3C8D1' })
hi('Identifier', { fg = '#8FA1B3' })
hi('Keyword', { fg = p.purple })
hi('Type', { fg = p.cyan })
hi('Constant', { fg = p.blue })
hi('Statement', { fg = p.purple })
hi('Operator', { fg = p.fg })
hi('String', { fg = p.green })
hi('Number', { fg = p.blue })
hi('Boolean', { fg = p.purple })
hi('Special', { fg = p.purple })

hi('DiagnosticError', { fg = p.red })
hi('DiagnosticWarn', { fg = p.yellow })
hi('DiagnosticInfo', { fg = p.blue })
hi('DiagnosticHint', { fg = p.cyan })

hi('@comment', { fg = p.comment, italic = true })
hi('@keyword', { fg = p.purple })
hi('@function', { fg = p.blue_bright })
hi('@type', { fg = p.cyan })
hi('@constant', { fg = p.blue })

hi('StatusLine', { fg = p.fg, bg = p.bg_alt })
hi('StatusLineNC', { fg = p.comment, bg = p.bg })
hi('PmenuSel', { bg = p.bg_alt })
hi('TabLineSel', { bg = p.bg_alt })
hi('MoreMsg', { fg = p.green })

hi('@tag', { fg = p.purple })
hi('@tag.delimiter', { fg = p.fg })
hi('@tag.tsx', { fg = p.blue })
hi('@constructor.tsx', { fg = p.blue })
hi('@tag.attribute', { fg = p.cyan })
hi('@text', { fg = p.fg })
hi('@text.jsx', { fg = p.fg })
hi('@punctuation.bracket', { fg = p.fg })
hi('@punctuation.delimiter', { fg = p.fg })
hi('@variable.jsx', { fg = p.fg })
hi('@string.jsx', { fg = p.green })
hi('@boolean.jsx', { fg = p.purple })
hi('@character.special.jsx', { fg = p.purple })

hi('VertSplit', { fg = p.border, bg = p.bg })
hi('WinSeparator', { fg = p.border, bg = p.bg })

hi('GitSignsAdd', { fg = p.green })
hi('GitSignsChange', { fg = p.cyan })
hi('GitSignsDelete', { fg = p.red })
hi('GitSignsAddLn', { bg = '#0F1A14' })
hi('GitSignsChangeLn', { bg = '#0E171C' })
hi('GitSignsDeleteLn', { bg = '#1A1014' })
hi('GitSignsAddNr', { fg = p.green })
hi('GitSignsChangeNr', { fg = p.cyan })
hi('GitSignsDeleteNr', { fg = p.red })
hi('DiffAdd', { bg = '#13241B' })
hi('DiffChange', { bg = '#132029' })
hi('DiffDelete', { bg = '#24161A' })
hi('DiffText', { bg = '#1C2E3A' })

hi('Directory', { fg = p.blue })
