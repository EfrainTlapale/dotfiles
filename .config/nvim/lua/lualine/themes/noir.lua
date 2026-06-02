local p = {
  bg = '#262D31',
  bg_alt = '#2E383C',
  fg = '#DFDFE0',
  fg_dim = '#B4BBC8',
  comment = '#7C8395',

  accent = '#9BBEFF',
  keyword = '#A6D6A6',

  git_add = '#9ED4B0',
  git_del = '#D28A8A',
}

return {
  normal = {
    a = { fg = p.bg, bg = p.comment, gui = 'bold' },
    b = { fg = p.fg, bg = p.bg_alt },
    c = { fg = p.fg_dim, bg = p.bg },
  },

  insert = {
    a = { fg = p.bg, bg = p.accent, gui = 'bold' },
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
