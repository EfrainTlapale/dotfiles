-- Name: logic_focus (Muted Version)
-- Description: A minimalist, logic-first colorscheme for Neovim with soft colors.

vim.cmd 'hi clear'
if vim.fn.exists 'syntax_on' == 1 then
  vim.cmd 'syntax reset'
end

vim.o.termguicolors = true
vim.g.colors_name = 'logic_focus'

-- ==========================================
-- Muted Color Palette
-- ==========================================
local colors = {
  bg = '#0A0A0C', -- Very deep, slightly cool dark background
  fg = '#9A9FA5', -- Normal text (dimmed gray)

  -- The TWO base colors for logic (Muted & Softer)
  var_blue = '#7B9EA8', -- Variables, Parameters: Dusty Slate Blue
  func_sand = '#C4AE78', -- Functions, Methods: Soft Sand/Muted Gold

  -- Muted colors for syntax boilerplate
  keyword = '#454A54', -- Keywords, Conditionals (Muted deep gray)
  operator = '#3B4048', -- Operators, Punctuation
  string = '#5A626A', -- Strings
  comment = '#2B2E33', -- Comments (Barely visible)

  -- UI elements
  ui_bg = '#141517',
  ui_border = '#24262A',
  cursorline = '#17181A',
  selection = '#2E333D',

  -- Diagnostics (Also muted to match the vibe)
  error = '#B56D73',
  warn = '#B59E6B',
  info = '#6B92A1',
  hint = '#7E8590',
}

-- ==========================================
-- Highlight Application Function
-- ==========================================
local function set_hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ==========================================
-- Base Highlights
-- ==========================================
local highlights = {
  Normal = { fg = colors.fg, bg = colors.bg },
  NormalFloat = { fg = colors.fg, bg = colors.ui_bg },
  ColorColumn = { bg = colors.cursorline },
  Cursor = { fg = colors.bg, bg = colors.var_blue },
  CursorLine = { bg = colors.cursorline },
  CursorLineNr = { fg = colors.var_blue, bold = true },
  LineNr = { fg = colors.comment },
  VertSplit = { fg = colors.ui_border },
  Visual = { bg = colors.selection },
  Search = { fg = colors.bg, bg = colors.func_sand },
  IncSearch = { fg = colors.bg, bg = colors.var_blue },
  Pmenu = { fg = colors.fg, bg = colors.ui_bg },
  PmenuSel = { fg = colors.bg, bg = colors.var_blue },

  -- Standard Syntax (Fallback)
  Comment = { fg = colors.comment, italic = true },
  String = { fg = colors.string },
  Number = { fg = colors.var_blue },
  Boolean = { fg = colors.var_blue, italic = true },

  -- Muted Keywords & Punctuation
  Statement = { fg = colors.keyword },
  Conditional = { fg = colors.keyword },
  Repeat = { fg = colors.keyword },
  Label = { fg = colors.keyword },
  Operator = { fg = colors.operator },
  Keyword = { fg = colors.keyword },
  Exception = { fg = colors.keyword },
  PreProc = { fg = colors.keyword },
  Include = { fg = colors.keyword },
  Define = { fg = colors.keyword },
  Macro = { fg = colors.keyword },
  Type = { fg = colors.keyword },
  StorageClass = { fg = colors.keyword },
  Structure = { fg = colors.keyword },
  Typedef = { fg = colors.keyword },
  Special = { fg = colors.operator },
  Delimiter = { fg = colors.operator },

  -- Variables and Functions (THE FOCUS)
  Identifier = { fg = colors.var_blue },
  Function = { fg = colors.func_sand, bold = true },
}

-- ==========================================
-- Treesitter Highlights
-- ==========================================
local treesitter = {
  ['@variable'] = { fg = colors.var_blue },
  ['@variable.builtin'] = { fg = colors.var_blue, italic = true },
  ['@parameter'] = { fg = colors.var_blue, italic = true },
  ['@property'] = { fg = colors.var_blue },
  ['@field'] = { fg = colors.var_blue },

  ['@function'] = { fg = colors.func_sand, bold = true },
  ['@function.builtin'] = { fg = colors.func_sand, bold = true },
  ['@function.macro'] = { fg = colors.func_sand },
  ['@method'] = { fg = colors.func_sand, bold = true },
  ['@constructor'] = { fg = colors.func_sand },

  ['@keyword'] = { fg = colors.keyword },
  ['@keyword.function'] = { fg = colors.keyword },
  ['@keyword.operator'] = { fg = colors.operator },
  ['@keyword.return'] = { fg = colors.keyword },
  ['@conditional'] = { fg = colors.keyword },
  ['@repeat'] = { fg = colors.keyword },
  ['@exception'] = { fg = colors.keyword },
  ['@include'] = { fg = colors.keyword },

  ['@type'] = { fg = colors.keyword },
  ['@type.builtin'] = { fg = colors.keyword },
  ['@type.qualifier'] = { fg = colors.keyword },

  ['@string'] = { fg = colors.string },
  ['@number'] = { fg = colors.var_blue },
  ['@boolean'] = { fg = colors.var_blue },
  ['@operator'] = { fg = colors.operator },
  ['@punctuation.bracket'] = { fg = colors.operator },
  ['@punctuation.delimiter'] = { fg = colors.operator },
}

-- ==========================================
-- LSP Highlights
-- ==========================================
local lsp = {
  -- Semantic Tokens
  ['@lsp.type.variable'] = { fg = colors.var_blue },
  ['@lsp.type.parameter'] = { fg = colors.var_blue, italic = true },
  ['@lsp.type.property'] = { fg = colors.var_blue },
  ['@lsp.type.function'] = { fg = colors.func_sand, bold = true },
  ['@lsp.type.method'] = { fg = colors.func_sand, bold = true },
  ['@lsp.type.keyword'] = { fg = colors.keyword },
  ['@lsp.type.class'] = { fg = colors.keyword },
  ['@lsp.type.interface'] = { fg = colors.keyword },

  -- Diagnostics
  DiagnosticError = { fg = colors.error },
  DiagnosticWarn = { fg = colors.warn },
  DiagnosticInfo = { fg = colors.info },
  DiagnosticHint = { fg = colors.hint },
  DiagnosticUnderlineError = { undercurl = true, sp = colors.error },
  DiagnosticUnderlineWarn = { undercurl = true, sp = colors.warn },
  DiagnosticUnderlineInfo = { undercurl = true, sp = colors.info },
  DiagnosticUnderlineHint = { undercurl = true, sp = colors.hint },
}

-- Apply all highlights
for group, opts in pairs(highlights) do
  set_hl(group, opts)
end
for group, opts in pairs(treesitter) do
  set_hl(group, opts)
end
for group, opts in pairs(lsp) do
  set_hl(group, opts)
end
