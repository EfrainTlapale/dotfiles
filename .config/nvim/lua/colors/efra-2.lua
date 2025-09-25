-- colors/yourtheme.lua

-- Color palette
local colors = {
  -- Base
  bg          = "#14171A",
  bg_alt      = "#1A1D21",
  fg          = "#C9D1D9",
  fg_alt      = "#A0A8B0",

  -- UI
  cursor_line = "#1E2227",
  selection   = "#2A2E34",
  line_nr     = "#3A3F45",
  comment     = "#5A6A73",
  status_bg   = "#1C1F24",
  status_fg   = "#A8B0B8",

  -- Syntax / Accents
  green       = "#96B088",
  blue        = "#7E9AAB",
  cyan        = "#88B0B0",
  yellow      = "#C2B388",
  orange      = "#B0977D",
  red         = "#B07777",
  purple      = "#A68CB3",
  alt_green   = "#8CA894",
  alt_blue    = "#7E9AAB",

  -- Diagnostics
  error       = "#B07777",
  warn        = "#C2B388",
  info        = "#7E9AAB",
  hint        = "#96B088",
}

-- Highlights table
local highlights = {
  -- Editor UI
  Normal                 = { fg = colors.fg, bg = colors.bg },
  CursorLine             = { bg = colors.cursor_line },
  Visual                 = { bg = colors.selection },
  LineNr                 = { fg = colors.line_nr },
  CursorLineNr           = { fg = colors.fg },
  SignColumn             = { bg = colors.bg },
  StatusLine             = { fg = colors.status_fg, bg = colors.bg },
  StatusLineNC           = { fg = colors.status_fg, bg = colors.bg_alt },
  MsgArea                = { fg = colors.fg, bg = colors.bg },
  ModeMsg                = { fg = colors.fg, bg = colors.bg },
  WinSeparator           = { fg = colors.bg },
  Directory              = { fg = colors.blue },
  NormalFloat            = { fg = colors.fg, bg = colors.bg },
  FloatBorder            = { fg = colors.status_fg, bg = colors.bg },

  -- Syntax
  Comment                = { fg = colors.comment, italic = true },
  String                 = { fg = colors.green },
  Number                 = { fg = colors.orange },
  Boolean                = { fg = colors.orange },
  Identifier             = { fg = colors.blue },
  Function               = { fg = colors.blue },
  Keyword                = { fg = colors.purple, bold = true },
  Type                   = { fg = colors.cyan },
  Constant               = { fg = colors.orange },
  Operator               = { fg = colors.cyan },
  Statement              = { fg = colors.purple },
  Special                = { fg = colors.alt_blue },
  ["@tag.attribute.tsx"] = { fg = colors.alt_green },

  -- Diagnostics
  DiagnosticError        = { fg = colors.error },
  DiagnosticWarn         = { fg = colors.warn },
  DiagnosticInfo         = { fg = colors.info },
  DiagnosticHint         = { fg = colors.hint },

  -- Completion
  Pmenu                  = { fg = colors.fg, bg = colors.bg_alt },
  PmenuSel               = { fg = colors.bg, bg = colors.blue },
  PmenuThumb             = { bg = colors.blue },

  -- Search
  Search                 = { fg = colors.bg, bg = colors.yellow },
  IncSearch              = { fg = colors.bg, bg = colors.orange },

  -- Git Signs (if using gitsigns.nvim)
  GitSignsAdd            = { fg = colors.green },
  DiffAdd                = { fg = colors.green },
  DiffDelete             = { fg = colors.red },
  GitSignsChange         = { fg = colors.blue },
  GitSignsDelete         = { fg = colors.red },

  TermCursor             = { fg = 'NONE', bg = 'NONE' },


  -- Snacks
  SnacksDashboardFile = { fg = colors.cyan },
  SnacksDashboardHeader = { fg = colors.purple },

  -- force lualine colors
  lualine_visual = { bold = true, bg = colors.purple },
}

-- Apply highlights
local function apply_highlights(highlights)
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Theme loader
local function load_theme()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "efra-2"

  apply_highlights(highlights)
end

-- Load theme
load_theme()
