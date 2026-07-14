-- Accent follows colors/noir-mono.lua (set there via vim.g.noir_mono_accent),
-- so the green/blue toggle lives in one place.
local accent = vim.g.noir_mono_accent or '#96B7A0'

local p = {
  bg = '#212526',
  bg_alt = '#2A2F30',
  fg = '#C9CDCB',
  fg_dim = '#9CA4A1',
  comment = '#5F6764',
  git_del = '#B08585',
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
