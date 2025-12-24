local p = {
  bg = '#08090B',
  bg_alt = '#0E1014',
  fg = '#D6DAE0',
  fg_dim = '#A3A8B1',
  comment = '#6B7280',

  accent = '#7F9FBF',
  keyword = '#8FAF8F',

  git_add = '#7F9F88',
  git_del = '#9A6B6B',
}

return {
  normal = {
    a = { fg = p.bg, bg = p.accent, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  insert = {
    a = { fg = p.bg, bg = p.accent, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  visual = {
    a = { fg = p.bg, bg = p.keyword, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  replace = {
    a = { fg = p.bg, bg = p.git_del, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  command = {
    a = { fg = p.bg, bg = p.keyword, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  inactive = {
    a = { fg = p.comment, bg = p.bg },
    b = { fg = p.comment, bg = p.bg },
    c = { fg = p.comment, bg = p.bg },
  },
}
