local dotenv = require('lua-dotenv')
dotenv.load_dotenv('./.env.local')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  'nvim-treesitter/nvim-treesitter-textobjects',
  'JoosepAlviste/nvim-ts-context-commentstring',
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  'f-person/git-blame.nvim',
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    tag = 'v3.8.2',
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  'kyazdani42/nvim-web-devicons',
  'kdheepak/lazygit.nvim',
  { 'sindrets/diffview.nvim',      dependencies = { 'nvim-lua/plenary.nvim' } },
  { "shortcuts/no-neck-pain.nvim", version = "*" },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true }
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  'kkharji/sqlite.lua',
  'prochri/telescope-all-recent.nvim',
  'lewis6991/gitsigns.nvim',
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        actions = {
          open_file = {
            quit_on_open = true
          }
        }
      }
    end
  },
  'numToStr/Comment.nvim',
  'm4xshen/autoclose.nvim',
  { "akinsho/toggleterm.nvim", version = '*' },
  'JellyApple102/flote.nvim',
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig"
  },
  'MunifTanjim/nui.nvim',
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  },
  'liangxianzhe/floating-input.nvim',
  'RishabhRD/popfix',
  'RishabhRD/nvim-lsputils',
  'nvim-telescope/telescope-ui-select.nvim',
  'rcarriga/nvim-notify',
  { 'dmmulroy/tsc.nvim',       version = 'v1.6.0' },
  {
    'stevearc/conform.nvim',
    opts = {},
  },
  'windwp/nvim-ts-autotag',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    'fredeeb/tardis.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    enabled = function()
      return dotenv.enable_plugin('ENABLE_TARDIS')
    end
  },
  'navarasu/onedark.nvim',
  'yioneko/nvim-vtsls',
  {
    'mistweaverco/kulala.nvim',
    opts = {},
    keys = {
      { '<CR>',       "<cmd>lua require('kulala').run()<CR>",       ft = "http" },
      { '[r',         "<cmd>lua require('kulala').jump_prev()<CR>", ft = "http" },
      { ']r',         "<cmd>lua require('kulala').jump_next()<CR>", ft = "http" },
      { '<leader>ci', "<cmd>lua require('kulala').from_curl()<CR>", ft = "http" },
      { '<leader>co', "<cmd>lua require('kulala').copy()<CR>",      ft = "http" },
      { '<leader>sr', "<cmd>lua require('kulala').search()<CR>",    ft = "http" },
      { '<leader>ck', "<cmd>lua require('kulala').close()<CR>",     ft = "http" },
    }
  },
  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  {
    'mawkler/refjump.nvim',
    -- keys = { ']r', '[r' }, -- Uncomment to lazy load
    opts = {}
  },
  {
    "kvrohit/rasmus.nvim",
    priority = 1000,
    config = function()
      -- vim.cmd([[colorscheme rasmus]])
    end,
  },
}

require('basics')

-- Setup lazy.nvim
require("lazy").setup({
  spec = plugins,
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
})

-- Setup neovim lua configuration
require('neodev').setup()
require('colors')
require('telescope-config')
require("flote").setup {
  window_border = 'single',
  files = {
    cwd = function()
      local bufPath = vim.api.nvim_buf_get_name(0)
      local cwd = require("lspconfig").util.root_pattern ".git" (bufPath)

      return cwd
    end,
  },
}
require('gitblame').setup({
  enabled = false
})
require("autoclose").setup({})
require('tsc').setup()
require('lualine').setup({
  sections = {
    lualine_b = { 'diff', 'diagnostics' },
    lualine_c = { 'filename', 'navic' },
    lualine_x = { 'filetype' },
  },
  tabline = {
    lualine_c = { 'branch', 'tabs' }
  }
})

vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup {
  enable_autocmd = false,
}

require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

require("noice").setup({
  lsp = {
    progress = {
      enabled = false
    },
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  messages = {
    enabled = false
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true,         -- use a classic bottom cmdline for search
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
})

require("toggleterm").setup {
  direction = 'horizontal',
  terminal_mappings = true,
  close_on_exit = true,
  float_opts = {
    border = 'curved',
    width = 180,
    height = 30,
    winblend = 3,
  },
}

require('gitblame').setup {
  enabled = false
}


require('lsp-config')

require('ibl').setup {
  indent = { char = { '┊' } },
  scope = { show_start = false, show_end = false, enabled = false }
}

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
    map({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line { full = true } end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    -- map('n', '<leader>hd', function() gs.diffthis('HEAD') end)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>')
  end
}

require("no-neck-pain").setup({
  width = 150
})

vim.notify = require('notify')

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will use the first available formatter in the list
    javascript = { "prettier_d", "prettier" },
    typescript = { "prettier_d", "prettier" },
    typescriptreact = { "prettier_d", "prettier" },
    sass = { "prettier_d", "prettier" },
    scss = { "prettier_d", "prettier" },
    css = { "prettier_d", "prettier" },
    json = { "prettier" }
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 10000,
    lsp_fallback = true,
  },
})

require('vtsls').config({})

vim.api.nvim_create_user_command('RunTests', ':<cmd>TermExec cmd="./run_tests_local.sh" direction="vertical" size=80',
  {})

vim.api.nvim_create_user_command('DismissNotifications', ":lua require('notify').dismiss()",
  {})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
  pattern = '.env*',
  command = 'set filetype=bash',
})

vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

-- QUICKER SETUP

vim.keymap.set("n", "<leader>q", function()
  require("quicker").toggle()
end, {
  desc = "Toggle quickfix",
})

require("quicker").setup({
  edit = { enabled = false },
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
})
