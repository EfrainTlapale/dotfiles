-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded             = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader          = " "
vim.o.number             = true
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

vim.api.nvim_set_keymap('n', 'vs', ':vs<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'sp', ':sp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tn', ':tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tl', ':tabnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'th', ':tabprev<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'to', ':tabo<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-N>', "<cmd>lua require('nvim-tree.api').tree.toggle(true)<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gb", ":GitBlameToggle<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>do", ":DiffviewOpen<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dc", ":DiffviewClose<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh", ":DiffviewFileHistory<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>ts", ":TSToggle highlight<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true })

vim.api.nvim_set_keymap('n', '<F4>', ':set hlsearch! hlsearch?<CR>', { noremap = true })

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

vim.g['better_escape_shortcut'] = { 'jk', 'jj', 'kj' }
