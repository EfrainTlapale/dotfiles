-- Accent follows colors/noir-black.lua (set there via vim.g.noir_black_accent),
-- so the accent toggle lives in one place.
local accent = vim.g.noir_black_accent or '#94ADC7'

local p = {
  bg = '#131118',
  bg_alt = '#1E1B26',
  fg = '#B9B5C4',
  fg_dim = '#8B8798',
  comment = '#595564',
  git_del = '#B08589',
}

return {
  normal = {
    a = { fg = p.bg, bg = p.comment, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  insert = {
    a = { fg = p.bg, bg = accent, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  visual = {
    a = { fg = p.bg, bg = p.fg_dim, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  replace = {
    a = { fg = p.bg, bg = p.git_del, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  command = {
    a = { fg = p.bg, bg = p.fg, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  inactive = {
    a = { fg = p.comment, bg = p.bg },
    b = { fg = p.comment, bg = p.bg },
    c = { fg = p.comment, bg = p.bg },
  },
}
