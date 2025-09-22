-- Set some basic theme options
vim.o.background = 'dark' -- or 'light'
vim.g.colors_name = 'efra'

-- Clear existing highlights to avoid conflicts
vim.cmd('highlight clear')

-- Define the GUI color palette
local colors = {
  -- bg = "#1D2326",
  -- bg = "#171D20",
  bg = "#14171A",
  fg = "#C0C0C0",
  black = "#242B2D",
  black_bright = "#485457",
  light_grey = "#C0C0C0",
  grey = "#7A7A73",
  red = "#BC8F7D",
  red_bright = "#D4A394",
  green = "#96B088",
  green_bright = "#ABC49E",
  yellow = "#CCAC7D",
  yellow_bright = "#E2BF8F",
  blue = "#7E9AAB",
  blue_bright = "#94B1C4",
  dark_blue = "#5F788F",
  magenta = "#A68CAA",
  magenta_bright = "#BC9EC0",
  cyan = "#839C98",
  cyan_bright = "#97B3AF",
  white = "#CED3DC",
  white_bright = "#E8EBF0",
  -- cursor = '#22292E'
  cursor = '#1D2326'
}

-- Define all highlight groups in a single table, using only the GUI colors
local highlights = {
  -- Basic Editor UI
  Normal = { fg = colors.fg, bg = colors.bg },
  SignColumn = { bg = colors.bg },
  MsgArea = { fg = colors.fg, bg = colors.bg },
  ModeMsg = { fg = colors.fg, bg = colors.bg },
  MsgSeparator = { fg = colors.fg, bg = colors.bg },
  MatchParen = { fg = colors.cyan, bg = colors.black_bright },
  Title = { fg = colors.yellow },
  Directory = { fg = colors.blue },

  -- Window separators
  WinSeparator = { fg = colors.black },

  -- Line Numbers and Cursor
  LineNr = { fg = colors.black_bright },
  CursorLineNr = { fg = colors.green },
  CursorLine = { bg = colors.cursor },
  CursorColumn = { bg = colors.bg },

  -- Search and Selection
  Search = { fg = colors.bg, bg = colors.blue_bright },
  IncSearch = { fg = colors.bg, bg = colors.yellow },
  Visual = { fg = "NONE", bg = colors.black },
  VisualNOS = { fg = "NONE", bg = colors.black },

  -- Statusline
  StatusLine = { fg = colors.fg, bg = colors.bg },
  StatusLineNC = { fg = colors.black_bright, bg = colors.bg },

  -- Syntax Highlighting
  Comment = { fg = colors.black_bright },
  Constant = { fg = colors.cyan },
  String = { fg = colors.cyan_bright },
  Identifier = { fg = colors.magenta },
  Function = { fg = colors.blue },
  Statement = { fg = colors.magenta },
  Operator = { fg = '#a7c080' },
  Keyword = { fg = colors.green },
  PreProc = { fg = colors.yellow },
  Type = { fg = colors.cyan },
  Special = { fg = colors.cyan_bright },
  ["@tag.attribute.tsx"] = { fg = colors.dark_blue },
  Delimiter = { fg = colors.cyan },
  ['@variable'] = { fg = colors.light_grey },

  -- Popup Menu
  Pmenu = { fg = colors.fg, bg = colors.black },
  PmenuSel = { fg = colors.bg, bg = colors.cyan },
  PmenuSbar = { bg = colors.black },
  PmenuThumb = { bg = colors.cyan },

  -- Floating windows
  FloatTitle = { fg = colors.blue, bg = colors.black },
  FloatBorder = { fg = colors.fg, bg = colors.bg },
  NormalFloat = { fg = colors.fg, bg = colors.bg },

  -- Diagnostics
  DiagnosticError = { fg = colors.red },
  DiagnosticWarn = { fg = colors.yellow },
  DiagnosticInfo = { fg = colors.blue },
  DiagnosticHint = { fg = colors.cyan },
  DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },
  DiagnosticUnderlineInfo = { sp = colors.blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = colors.cyan, undercurl = true },
  DiagnosticUnnecessary = { fg = colors.grey, undercurl = true },

  -- Status line
  StatusLineMode = { fg = colors.blue },
  StatusLinePath = { fg = colors.black_bright },
  StatusLineFlags = { fg = colors.yellow },
  StatusLineFileType = { fg = colors.black_bright },
  StatusLinePosition = { fg = colors.magenta },
  StatusLinePercent = { fg = colors.green },
  StatusLineModified = { fg = colors.yellow },
  StatusLineModeNormal = { fg = colors.blue },
  StatusLineModeInsert = { fg = colors.green },
  StatusLineModeVisual = { fg = colors.yellow },
  StatusLineModeCommand = { fg = colors.green },
  StatusLineModeReplace = { fg = colors.red },
  StatusLineModeTerminal = { fg = colors.cyan },

  -- nvim-telescope
  TelescopeNormal = { fg = colors.fg, bg = colors.bg },
  TelescopePromptNormal = { fg = colors.fg, bg = colors.bg },
  TelescopeResultsNormal = { fg = colors.fg, bg = colors.bg },
  TelescopeSelection = { fg = colors.fg, bg = colors.black },
  TelescopeMatching = { fg = colors.yellow },

  -- nvim-cmp
  CmpItemAbbr = { fg = colors.fg },
  CmpItemAbbrDeprecated = { fg = colors.black_bright, strikethrough = true },
  CmpItemMenu = { fg = colors.black_bright },
  CmpItemKindVariable = { fg = colors.magenta, bg = colors.bg },
  CmpItemKindFunction = { fg = colors.blue, bg = colors.bg },
  CmpItemKindMethod = { fg = colors.blue, bg = colors.bg },
  CmpItemKindClass = { fg = colors.yellow, bg = colors.bg },
  CmpItemKindInterface = { fg = colors.yellow, bg = colors.bg },
  CmpItemKindModule = { fg = colors.yellow, bg = colors.bg },
  CmpItemKindProperty = { fg = colors.magenta, bg = colors.bg },
  CmpItemKindField = { fg = colors.magenta, bg = colors.bg },
  CmpItemKindEnum = { fg = colors.yellow, bg = colors.bg },
  CmpItemKindSnippet = { fg = colors.cyan, bg = colors.bg },
  CmpItemKindFile = { fg = colors.fg, bg = colors.bg },
  CmpItemKindFolder = { fg = colors.fg, bg = colors.bg },
  CmpItemKindKeyword = { fg = colors.magenta, bg = colors.bg },
  CmpItemKindConstant = { fg = colors.cyan, bg = colors.bg },
  CmpItemKindOperator = { fg = colors.cyan, bg = colors.bg },
  CmpItemKindReference = { fg = colors.magenta, bg = colors.bg },
  CmpItemKindValue = { fg = colors.cyan, bg = colors.bg },
  CmpItemKindUnit = { fg = colors.cyan, bg = colors.bg },

  -- oil.nvim
  OilDir = { fg = colors.blue },
  OilFile = { fg = colors.fg },
  OilLink = { fg = colors.cyan },

  -- Tree-sitter
  TSAnnotation = { fg = colors.yellow },
  TSAttribute = { fg = colors.cyan },
  TSBoolean = { fg = colors.cyan },
  TSCharacter = { fg = colors.green },
  TSComment = { fg = colors.black_bright },
  TSConditional = { fg = colors.magenta },
  TSConstant = { fg = colors.cyan },
  TSConstBuiltin = { fg = colors.cyan_bright },
  TSConstMacro = { fg = colors.cyan },
  TSConstructor = { fg = colors.yellow },
  TSError = { fg = colors.red },
  TSException = { fg = colors.magenta },
  TSField = { fg = colors.magenta },
  TSFloat = { fg = colors.cyan },
  TSFunction = { fg = colors.blue },
  TSFuncBuiltin = { fg = colors.blue_bright },
  TSFuncMacro = { fg = colors.blue },
  TSInclude = { fg = colors.magenta },
  TSKeyword = { fg = colors.magenta },
  TSKeywordFunction = { fg = colors.magenta },
  TSKeywordOperator = { fg = colors.magenta },
  TSLabel = { fg = colors.yellow },
  TSMethod = { fg = colors.blue },
  TSNamespace = { fg = colors.yellow },
  TSNone = { fg = colors.fg },
  TSNumber = { fg = colors.cyan },
  TSOperator = { fg = colors.fg },
  TSParameter = { fg = colors.magenta },
  TSParameterReference = { fg = colors.magenta },
  TSProperty = { fg = colors.magenta },
  TSPunctDelimiter = { fg = colors.fg },
  TSPunctBracket = { fg = colors.fg },
  TSPunctSpecial = { fg = colors.fg },
  TSRepeat = { fg = colors.magenta },
  TSString = { fg = colors.green },
  TSStringRegex = { fg = colors.green_bright },
  TSStringEscape = { fg = colors.green_bright },
  TSSymbol = { fg = colors.cyan },
  TSTag = { fg = colors.yellow },
  TSTagDelimiter = { fg = colors.fg },
  TSText = { fg = colors.fg },
  TSTitle = { fg = colors.yellow },
  TSType = { fg = colors.cyan },
  TSTypeBuiltin = { fg = colors.cyan_bright },
  TSVariable = { fg = colors.magenta },

  -- mini.starter
  MiniStarterHeader = { fg = colors.blue },
  MiniStarterItem = { fg = colors.fg },
  MiniStarterItemBullet = { fg = colors.yellow },
  MiniStarterItemPrefix = { fg = colors.green },
  MiniStarterSection = { fg = colors.magenta },
  MiniStarterQuery = { fg = colors.cyan },
  MiniStarterFooter = { fg = colors.red },

  -- which-key.nvim
  WhichKey = { fg = colors.cyan },
  WhichKeySeparator = { fg = colors.black_bright },
  WhichKeyGroup = { fg = colors.blue },
  WhichKeyDesc = { fg = colors.green },
  WhichKeyFloat = { bg = colors.black },
  WhichKeyValue = { fg = colors.magenta },

  -- NvimTree
  NvimTreeNormal = { fg = colors.fg, bg = colors.bg },
  NvimTreeFolderName = { fg = colors.blue },
  NvimTreeOpenedFolderName = { fg = colors.blue_bright },
  NvimTreeEmptyFolderName = { fg = colors.black_bright },
  NvimTreeIndentMarker = { fg = colors.black_bright },
  NvimTreeVertSplit = { fg = colors.black, bg = colors.bg },
  NvimTreeRootFolder = { fg = colors.red },
  NvimTreeSymlink = { fg = colors.cyan },
  NvimTreeStatuslineNc = { fg = colors.black_bright, bg = colors.bg },

  -- -- snacks
  SnacksDashboardHeader = { fg = colors.blue_bright },
}

-- Loop through the table and apply the highlights
for group, settings in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, settings)
end
