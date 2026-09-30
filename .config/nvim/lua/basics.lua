vim.g.mapleader = ' '
vim.o.number = false
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.incsearch = true
vim.o.tabstop = 2
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.hlsearch = false
vim.o.swapfile = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 5
vim.o.errorbells = false
vim.o.shiftwidth = 2
vim.o.numberwidth = 1
vim.o.termguicolors = true
vim.o.showmode = false
vim.o.showtabline = 2
vim.o.signcolumn = 'yes:1'
vim.opt.path = vim.opt.path + '**'
vim.opt.mouse = ''
vim.opt.linebreak = true
vim.opt.wrap = true
vim.opt.hidden = true
vim.o.foldmethod = 'manual'
vim.o.foldlevelstart = 99
vim.api.nvim_set_var('vimwiki_folding', 'custom')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set(
  'n',
  'k',
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
vim.keymap.set(
  'n',
  'j',
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)

vim.api.nvim_set_keymap(
  'c',
  '<c-p>',
  [[ wildmenumode() ? "\<C-p>" : "\<up>" ]],
  { noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
  'c',
  '<c-n>',
  [[ wildmenumode() ? "\<C-n>" : "\<down>" ]],
  { noremap = true, expr = true }
)

vim.api.nvim_set_keymap('n', 'vs', '<cmd>vs<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'sp', '<cmd>sp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tn', '<cmd>tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tl', '<cmd>tabnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'th', '<cmd>tabprev<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'to', '<cmd>tabo<CR>', { noremap = true })
vim.api.nvim_set_keymap(
  't',
  '<Esc>',
  '<C-\\><C-n>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>gb',
  '<cmd>GitBlameToggle<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<leader>do',
  '<cmd>DiffviewOpen<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>cd',
  '<cmd>CodeDiff<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>dc',
  '<cmd>DiffviewClose<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>fh',
  '<cmd>DiffviewFileHistory %<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<leader>ts',
  '<cmd>TSToggle highlight<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<F4>',
  '<cmd>set hlsearch! hlsearch?<CR>',
  { noremap = true }
)

local function resize_relative(relativeNumber)
  local lines = vim.o.lines
  local factor = 1 / relativeNumber
  local newLines = lines * factor
  vim.cmd.resize(math.floor(newLines))
end

local function vertical_relative_resize(relativeNumber)
  local cols = vim.o.columns
  local factor = 1 / relativeNumber
  local newCols = math.floor(cols * factor)

  vim.cmd('vertical resize ' .. newCols)
end

vim.api.nvim_create_user_command('ResizeRelative', function(opts)
  resize_relative(opts.fargs[1])
end, { nargs = '*' })

vim.api.nvim_create_user_command('VerticalRelative', function(opts)
  vertical_relative_resize(opts.fargs[1])
end, { nargs = '*' })

vim.api.nvim_create_user_command('ToggleColors', function(opts)
  require('oklch-color-picker').highlight.toggle()
end, { nargs = '*' })

vim.keymap.set('n', '<leader>rh', ':ResizeRelative ')
vim.keymap.set('n', '<leader>rv', ':VerticalRelative ')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')

vim.keymap.set({ 'n' }, '<leader>tm', '<cmd>ToggleTerm<CR>')
vim.keymap.set(
  { 'n' },
  '<leader>tv',
  '<cmd>ToggleTerm direction=vertical size=100<CR>'
)
vim.keymap.set(
  { 'n' },
  '<leader>tt',
  '<cmd>ToggleTerm direction=float size=30<CR>'
)

vim.keymap.set({ 'n' }, '<leader>nn', '<cmd>NoNeckPain<CR>')

vim.api.nvim_create_autocmd('ExitPre', {
  pattern = '*',
  callback = function(event)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local ok, buftype =
        pcall(vim.api.nvim_get_option_value, 'buftype', { buf = buf })
      if ok and buftype == 'terminal' then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
})

-- remap / when visual selection is active to only search inside the selection
vim.keymap.set('x', '/', '<Esc>/\\%V')

-- Filetype detection
vim.filetype.add({
  extension = { ['http'] = 'http' },
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
  pattern = '.env*',
  command = 'set filetype=bash',
})

vim.api.nvim_create_user_command('GitStatus', function(opts)
  require('minifugit').status()
end, { nargs = '*' })

vim.keymap.set('n', '<leader>;', function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local last_char = string.sub(line, -1, -1)
  if last_char == ';' then
    vim.cmd 's/;$//'
    vim.cmd ':nohlsearch'
  else
    vim.cmd 'norm A;'
  end
  vim.api.nvim_win_set_cursor(0, cursor)
end, { desc = 'Toggle semicolon in current line' })

local function copy_selection_with_context()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  local lines = vim.fn.getline(start_line, end_line)
  local filepath = vim.fn.expand '%:.' -- relative to cwd; use '%:p' for absolute
  local filetype = vim.bo.filetype

  local range_str = start_line == end_line and ('line ' .. start_line)
    or ('lines ' .. start_line .. '-' .. end_line)

  local header = string.format('%s (%s):', filepath, range_str)
  local code_block =
    string.format('```%s\n%s\n```', filetype, table.concat(lines, '\n'))
  local result = header .. '\n' .. code_block

  vim.fn.setreg('+', result)
  vim.notify('Copied ' .. range_str .. ' from ' .. filepath .. ' to clipboard')
end

vim.keymap.set('v', '<leader>cc', function()
  vim.cmd 'normal! \27' -- \27 is the literal Escape byte, this works in a string
  copy_selection_with_context()
end, { desc = 'Copy selection with file/line context' })
