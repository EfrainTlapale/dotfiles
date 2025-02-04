-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded             = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader          = " "
vim.o.number             = false
vim.o.relativenumber     = true
vim.o.wrap               = false
vim.o.expandtab          = true
vim.o.incsearch          = true
vim.o.tabstop            = 2
vim.o.cursorline         = true
vim.o.ignorecase         = true
vim.o.hlsearch           = false
vim.o.swapfile           = false
vim.o.splitbelow         = true
vim.o.splitright         = true
vim.o.scrolloff          = 3
vim.o.errorbells         = false
vim.o.shiftwidth         = 2
vim.o.numberwidth        = 4
vim.o.termguicolors      = true
vim.o.showmode           = false
vim.o.showtabline        = 2
vim.o.signcolumn         = 'yes'
vim.opt.path             = vim.opt.path + "**"
vim.opt.mouse            = ''
vim.opt.linebreak        = true
vim.opt.wrap             = true
vim.opt.hidden           = true
vim.o.foldmethod         = 'manual'
vim.o.foldlevelstart     = 99
vim.api.nvim_set_var('vimwiki_folding', 'custom')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.api.nvim_set_keymap("c", "<c-p>", [[ wildmenumode() ? "c-k>" : "<up>" ]], { noremap = true, expr = true })
vim.api.nvim_set_keymap("c", "<c-n>", [[ wildmenumode() ? "c-k>" : "<down>" ]], { noremap = true, expr = true })

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
vim.api.nvim_set_keymap('n', '<C-N>', "<cmd>lua require('nvim-tree.api').tree.toggle(true)<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>GitBlameToggle<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>DiffviewFileHistory<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd>TSToggle highlight<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<A-j>', '<cmd>m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-k>', '<cmd>m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-j>', "<cmd>m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<A-k>', "<cmd>m '<-2<CR>gv=gv", { noremap = true })

vim.api.nvim_set_keymap('n', '<F4>', '<cmd>set hlsearch! hlsearch?<CR>', { noremap = true })

local function open_nvim_tree(data)
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end


vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.g["netrw_banner"] = 0
vim.g["netrw_liststyle"] = 3
vim.g["netrw_winsize"] = 25



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


vim.keymap.set('n', '<leader>rh', ':ResizeRelative ')
vim.keymap.set('n', '<leader>rv', ':VerticalRelative ')
