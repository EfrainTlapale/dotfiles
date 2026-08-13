-- selene: a narrow-palette spinoff of luna.nvim (wtfox/luna.nvim).
--
-- Luna's identity is four accent hues over near-black: orange keywords, blue
-- functions, purple types, green strings. selene keeps luna's entire highlight
-- surface (every plugin group it ships) but narrows the palette to TWO hues
-- plus one UI signal. Everything else -- greys, surfaces, borders, selections,
-- diff backgrounds -- is derived from bg/fg/accent by blending, so a full theme
-- is described by five hex values.
--
-- To switch palettes: uncomment exactly one block below, then reload
-- (`:colorscheme selene`). That's the whole mechanism.

local Util = require 'luna.util'

--------------------------------------------------------------------------------
-- Palettes -- pick one.
--
--   bg      near-black canvas
--   fg      normal text; the whole grey ramp is this color faded toward bg,
--           so its tint (cool / warm / lavender) colors all the chrome
--   accent  the hue you read code by: functions, and muted/pale variants of it
--           become keywords and types
--   accent2 literals: strings and numbers
--   signal  UI cue only, never syntax: search, cursor-line-nr hits, git change,
--           dashboard keys
--
-- Optional per-palette overrides: error, warning, ok (defaults below the list).
--------------------------------------------------------------------------------

-- stylua: ignore
local pal = { -- selene: cool near-black, steel-blue accent, sage literals (new)
  bg      = '#07080a',
  fg      = '#c9ccd2',
  accent  = '#7fa3c6',
  accent2 = '#93ae96',
  signal  = '#c18f66',
}

-- stylua: ignore
-- local pal = { -- obsidian: OLED black, violet accent, dusty blue literals (new)
--   bg      = '#000000',
--   fg      = '#bdb8c8',
--   accent  = '#a48fc0',
--   accent2 = '#8aa3c0',
--   signal  = '#c09a72',
-- }

-- stylua: ignore
-- local pal = { -- ember: warm near-black, amber accent, olive literals (new)
--   bg      = '#080706',
--   fg      = '#dcd2c6',
--   accent  = '#cf9a6e',
--   accent2 = '#a3a284',
--   signal  = '#b8794f',
-- }

-- stylua: ignore
-- local pal = { -- tide: ink-blue black, teal accent, steel literals (new)
--   bg      = '#04070a',
--   fg      = '#c3ccd0',
--   accent  = '#6fa8a5',
--   accent2 = '#8ba2b8',
--   signal  = '#c9a06b',
-- }

-- stylua: ignore
-- local pal = { -- noir-blue: your noir-black blue accent + its green (borrowed)
--   bg      = '#000000',
--   fg      = '#b9b5c4',
--   accent  = '#94adc7',
--   accent2 = '#96b7a0',
--   signal  = '#bfa07d',
-- }

-- stylua: ignore
-- local pal = { -- nord-abyss: nordstone's nord hues dropped onto near-black (borrowed)
--   bg      = '#0b0e13',
--   fg      = '#d8dee9',
--   accent  = '#81a1c1', -- nord9
--   accent2 = '#a3be8c', -- nord14
--   signal  = '#d08770', -- nord12
--   error   = '#bf616a', -- nord11
--   warning = '#ebcb8b', -- nord13
--   ok      = '#a3be8c',
-- }

-- stylua: ignore
-- local pal = { -- luna-narrow: luna's own func/string/signal, purple+orange dropped
--   bg      = '#060606',
--   fg      = '#e4e4e8',
--   accent  = '#75a1c7',
--   accent2 = '#9eb38e',
--   signal  = '#c2916a',
-- }

-- Diagnostics are semantics, not identity: shared across every palette above
-- unless a palette overrides them.
local defaults = {
  error = '#d78a8a',
  warning = '#cca25f',
  ok = '#74ab7f',
}

--------------------------------------------------------------------------------
-- Derivation
--------------------------------------------------------------------------------

---@param p table five-value palette
---@return table full luna-shaped palette
local function derive(p)
  local bg = p.bg
  local fg = p.fg
  local err = p.error or defaults.error
  local warn = p.warning or defaults.warning
  local ok = p.ok or defaults.ok

  -- fade a color toward the background
  local function fade(hex, a)
    return Util.blend(hex, a, bg)
  end
  -- lift a color toward white
  local function lift(hex, a)
    return Util.blend('#ffffff', a, hex)
  end

  local grey_light = fade(fg, 0.73)
  local silver = fade(fg, 0.88)

  local c = {
    -- Surfaces, dark to darkest
    bg = bg,
    bg_alt = fade(fg, 0.10),
    bg_soft = fade(fg, 0.12),
    bg_plum = fade(p.signal, 0.26), -- Search background
    bg_delete = fade(err, 0.22),
    surface = fade(fg, 0.20),
    selection = fade(p.accent, 0.24),
    border = fade(fg, 0.26),
    float_bg = fade(fg, 0.24),

    -- Grey ramp: fg faded toward bg, so it inherits the fg tint
    grey_warm = fade(fg, 0.40),
    comment = fade(fg, 0.50),
    grey = fade(fg, 0.58),
    grey_mid = fade(fg, 0.66),
    grey_light = grey_light,
    grey_pale = fade(fg, 0.80),
    silver = silver,
    fg = fg,
    fg_bright = lift(fg, 0.30),
    cream = lift(p.signal, 0.55),

    -- Foundation
    black = '#000000',
    white = '#ffffff',

    -- Syntax: two hues. The accent appears at three strengths -- dim, full,
    -- pale -- so keywords/functions/types separate by weight, not by hue.
    func = p.accent, -- full accent
    keyword = Util.blend(p.accent, 0.60, fade(fg, 0.58)), -- dimmer, less chroma
    type = Util.blend(p.accent, 0.40, silver), -- pale wash
    string = p.accent2,
    number = Util.blend(p.accent2, 0.55, grey_light),
    signal = p.signal,

    -- Diagnostics
    error = err,
    warning = warn,
    info = Util.blend(p.accent, 0.45, grey_light),
    hint = fade(fg, 0.62),
    ok = ok,

    none = 'NONE',
  }

  c.diag = {
    error = c.error,
    warning = c.warning,
    info = c.info,
    hint = c.hint,
    ok = c.ok,
  }

  -- Diff backgrounds are tints of the same hue as their fg, so the family reads
  -- as one thing. `text` (word-level) is stronger since it marks the changed
  -- span inside an already-tinted line.
  c.git = {
    add = { fg = c.ok, bg = fade(c.ok, 0.14) },
    delete = { fg = c.error, bg = c.bg_delete },
    change = { fg = c.signal, bg = fade(c.signal, 0.10) },
    text = { fg = c.fg_bright, bg = fade(c.signal, 0.28) },
  }

  c.cursor_line = { bg = fade(fg, 0.085) }
  c.cursor_line_nr = { fg = c.silver }
  c.line_nr = fade(fg, 0.30)
  c.visual = fade(p.accent, 0.18)
  c.float_border = c.border

  return c
end

--------------------------------------------------------------------------------
-- Load: luna's own highlight engine, our palette
--------------------------------------------------------------------------------

local colors = derive(pal)

require('luna.highlights').setup({
  transparent = false,
  accent = 1.0,
  plugins = { all = true, auto = true },

  on_colors = function(c)
    for k, v in pairs(colors) do
      c[k] = v
    end
  end,

  -- Narrowing pass: a few groups luna colors from hues selene doesn't have.
  on_highlights = function(hl, c)
    hl.Title = { fg = c.silver, bold = true }
    hl.TabLineSel = { fg = c.fg, bg = c.bg, bold = true }
    hl.ModeMsg = { fg = c.grey_light }
    hl.Question = { fg = c.grey_light }
    hl.MatchParen = { fg = c.fg_bright, bg = c.surface, bold = true }
    hl.Directory = { fg = c.type }
    hl.WinSeparator = { fg = c.border }
    hl.VertSplit = { fg = c.border }
    hl.CursorLineNr = { fg = c.signal, bold = true }
    hl.NonText = { fg = c.grey_warm }
    hl.SignColumn = { fg = c.grey_warm, bg = c.none }
    hl.DiagnosticUnnecessary = { fg = c.grey_warm, undercurl = true }

    -- Snacks picker: luna leaves these to snacks' own defaults, which read flat
    -- on a near-black float.
    hl.SnacksPickerMatch = { fg = c.signal, bold = true }
    hl.SnacksPickerDir = { fg = c.comment }
    hl.SnacksPickerListCursorLine = { bg = c.selection }
    hl.SnacksPickerInputSearch = { fg = c.signal }
    hl.SnacksPickerPrompt = { fg = c.grey_light }
  end,
})

vim.o.background = 'dark'
vim.g.colors_name = 'selene'
