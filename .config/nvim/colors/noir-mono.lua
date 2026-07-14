-- noir-mono: a stripped-down noir. One muted accent hue, everything else gray.
-- Toggle the accent: comment the active block, uncomment the other one.

-- How colorful the accents get: 0 = grayscale, 1 = neon.
-- The base hexes below sit around 0.30, so raise this for more punch.
local vibrancy = 0.35

-- stylua: ignore
-- local accent = { -- green
--   fg            = '#96B7A0',
--   dim           = '#7C9885',
--   search_bg     = '#26382E',
--   search_cur_bg = '#33493C',
-- }

-- stylua: ignore
local accent = { -- blue
  fg            = '#94ADC7',
  dim           = '#7A93AB',
  search_bg     = '#243240',
  search_cur_bg = '#304354',
}

local palette = {
  bg = '#191C1D',
  bg_alt = '#212526',
  fg = '#C9CDCB',
  fg_dim = '#9CA4A1',
  comment = '#5F6764',
  border = '#2C3233',
  nontext = '#373E40',

  visual_bg = '#2A2F30',
  pmenu_sel_bg = '#2B3233',
  picker_sel_bg = '#333B3C',
  match_paren_bg = '#3A4344',

  git_del_fg = '#B08585',
  diag_error_fg = '#C08D8C',
  diag_warn_fg = '#BFAE8B',

  diff_add_bg = '#1B241E',
  diff_change_bg = '#232829',
  diff_del_bg = '#271D1E',
  diff_text_bg = '#2E3536',
}

local function hex_to_hsl(hex)
  local r = tonumber(hex:sub(2, 3), 16) / 255
  local g = tonumber(hex:sub(4, 5), 16) / 255
  local b = tonumber(hex:sub(6, 7), 16) / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local l = (max + min) / 2
  if max == min then
    return 0, 0, l
  end
  local d = max - min
  local s = d / (l > 0.5 and (2 - max - min) or (max + min))
  local h
  if max == r then
    h = (g - b) / d % 6
  elseif max == g then
    h = (b - r) / d + 2
  else
    h = (r - g) / d + 4
  end
  return h / 6, s, l
end

local function hsl_to_hex(h, s, l)
  local function f(n)
    local k = (n + h * 12) % 12
    local a = s * math.min(l, 1 - l)
    local c = l - a * math.max(-1, math.min(k - 3, 9 - k, 1))
    return math.floor(c * 255 + 0.5)
  end
  return string.format('#%02X%02X%02X', f(0), f(8), f(4))
end

-- Re-saturate a color to the vibrancy level, keeping its hue and lightness.
local function vivid(hex)
  local h, _, l = hex_to_hsl(hex)
  return hsl_to_hex(h, vibrancy, l)
end

for k, v in pairs(accent) do
  accent[k] = vivid(v)
end
palette.git_del_fg = vivid(palette.git_del_fg)
palette.diag_error_fg = vivid(palette.diag_error_fg)
palette.diag_warn_fg = vivid(palette.diag_warn_fg)

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

vim.cmd 'highlight clear'
vim.cmd 'syntax reset'

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.g.colors_name = 'noir-mono'
vim.g.noir_mono_accent = accent.fg

hi('Normal', { fg = palette.fg, bg = palette.bg })
hi('CursorLine', { bg = palette.bg_alt })
hi('Visual', { bg = palette.visual_bg })
hi('Directory', { fg = accent.dim })

hi('LineNr', { fg = palette.comment })
hi('CursorLineNr', { fg = accent.fg })
hi('VertSplit', { fg = palette.border, bg = palette.bg })
hi('WinSeparator', { fg = palette.border, bg = palette.bg })

hi('Comment', { fg = palette.comment, italic = true })
hi('String', { fg = palette.fg_dim })
hi('Function', { fg = accent.fg })
hi('Keyword', { fg = accent.dim })
hi('Statement', { fg = accent.dim })
hi('PreProc', { fg = palette.fg_dim })
hi('Type', { fg = palette.fg })
hi('Identifier', { fg = palette.fg })
hi('Operator', { fg = palette.fg_dim })
hi('Delimiter', { fg = palette.fg_dim })
hi('Constant', { fg = palette.fg_dim })
hi('Special', { fg = palette.fg_dim })

hi('StatusLine', { fg = palette.fg, bg = palette.bg_alt })
hi('StatusLineNC', { fg = palette.comment, bg = palette.bg })

hi('PmenuSel', {
  bg = palette.pmenu_sel_bg,
  fg = palette.fg,
  bold = true,
})

hi('@function', { fg = accent.fg })
hi('@keyword', { fg = accent.dim })
hi('@type', { fg = palette.fg })
hi('@variable', { fg = palette.fg })
hi('@comment', { fg = palette.comment, italic = true })

hi('@tag', { fg = accent.dim })
hi('@tag.delimiter', { fg = palette.fg_dim })
hi('@tag.attribute', { fg = palette.fg_dim })
hi('@constructor', { fg = palette.fg })

hi('@punctuation.bracket', { fg = palette.fg_dim })
hi('@punctuation.delimiter', { fg = palette.fg_dim })

hi('GitSignsAdd', { fg = accent.dim })
hi('GitSignsChange', { fg = palette.fg_dim })
hi('GitSignsDelete', { fg = palette.git_del_fg })

hi('GitSignsAddNr', { fg = accent.dim })
hi('GitSignsChangeNr', { fg = palette.fg_dim })
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
hi('DiffAdded', { bg = palette.diff_add_bg })
hi('DiffChanged', { bg = palette.diff_change_bg })
hi('DiffRemoved', { bg = palette.diff_del_bg })

hi('DiagnosticError', { fg = palette.diag_error_fg })
hi('DiagnosticWarn', { fg = palette.diag_warn_fg })
hi('DiagnosticInfo', { fg = palette.fg_dim })
hi('DiagnosticHint', { fg = palette.fg_dim })
hi('MoreMsg', { fg = accent.dim })

hi(
  'DiagnosticUnderlineError',
  { fg = 'NONE', bg = 'NONE', sp = palette.diag_error_fg, undercurl = true }
)
hi(
  'DiagnosticUnderlineWarn',
  { fg = 'NONE', bg = 'NONE', sp = palette.diag_warn_fg, undercurl = true }
)
hi(
  'DiagnosticUnderlineInfo',
  { fg = 'NONE', bg = 'NONE', sp = palette.fg_dim, undercurl = true }
)
hi(
  'DiagnosticUnderlineHint',
  { fg = 'NONE', bg = 'NONE', sp = palette.fg_dim, undercurl = true }
)
hi('FlashLabel', { fg = palette.bg, bg = accent.fg, bold = true })

-- Search / matching
hi('Search', { fg = palette.fg, bg = accent.search_bg })
hi('IncSearch', { fg = palette.fg, bg = accent.search_cur_bg, bold = true })
hi('CurSearch', { fg = palette.fg, bg = accent.search_cur_bg, bold = true })
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
hi('Title', { fg = accent.fg, bold = true })
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
hi('FloatTitle', { fg = accent.fg, bg = palette.bg_alt })
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
hi('SnacksPickerMatch', { fg = accent.fg, bold = true })
hi('SnacksPickerDir', { fg = palette.comment })
