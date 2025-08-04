local dotenv = require('lua-dotenv')
dotenv.load_dotenv(vim.fs.normalize('~/.config/nvim/.env.local'))

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
  'numToStr/Comment.nvim',
  'm4xshen/autoclose.nvim',
  { "akinsho/toggleterm.nvim", version = '*' },
  'JellyApple102/flote.nvim',
  {

  },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
    },
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
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  'saadparwaiz1/cmp_luasnip',
  'benfowler/telescope-luasnip.nvim',
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
  'navarasu/onedark.nvim',
  'yioneko/nvim-vtsls',
  {
    'mistweaverco/kulala.nvim',
    opts = {},
    ft = { "http", "rest" },
    keys = {
      { '<CR>',       "<cmd>lua require('kulala').run()<CR>",       ft = "http" },
      { '[r',         "<cmd>lua require('kulala').jump_prev()<CR>", ft = "http" },
      { ']r',         "<cmd>lua require('kulala').jump_next()<CR>", ft = "http" },
      { '<leader>ci', "<cmd>lua require('kulala').from_curl()<CR>", ft = "http" },
      { '<leader>co', "<cmd>lua require('kulala').copy()<CR>",      ft = "http" },
      { '<leader>o',  "<cmd>lua require('kulala').search()<CR>",    ft = "http" },
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
  {
    "S1M0N38/love2d.nvim",
    -- cmd = "LoveRun",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>v",  ft = "lua",          desc = "LÖVE" },
      { "<leader>vv", "<cmd>LoveRun<cr>",  ft = "lua",   desc = "Run LÖVE" },
      { "<leader>vs", "<cmd>LoveStop<cr>", ft = "lua",   desc = "Stop LÖVE" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = true
  },
  "fnune/codeactions-on-save.nvim",
  {
    "neanias/everforest-nvim",
    lazy = false,
    version = false,
    config = function()
      require("everforest").setup {
        background = "hard",
        disable_italic_comments = true,
      }
    end
  },
  "aktersnurra/no-clown-fiesta.nvim",
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  { "EdenEast/nightfox.nvim" },
  "shaunsingh/nord.nvim",
  "nyoom-engineering/oxocarbon.nvim",
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Recent Files", section = "recent_files", cwd = true },
          { section = "startup" },
        }
      },
      explorer = {
        replace_netrw = true
      },
      picker = {
        sources = {
          explorer = {
            jump = {
              close = true
            },
            enter = true,
            win = {
              list = {
                keys = {
                  ['<c-n>'] = { 'close', mode = { 'i', 'n' } }
                }
              }
            }
          },
        },
        matcher = {
          frecency = true,
          fuzzy = true
        },
        win = {
          input = {
            keys = {
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            }
          },
        },
        formatters = {
          file = { truncate = 60, filename_first = true }
        }
      },
      gitbrowse = {
        -- your gitbrowse configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
    keys = {
      { "<leader>o", function() Snacks.picker.lsp_symbols({ tree = false, filter = { default = true } }) end, desc = "LSP Symbols" },
      { "gd",        function() Snacks.picker.lsp_definitions() end,                                          desc = "Goto Definition" },
      { "gr",        function() Snacks.picker.lsp_references() end,                                           nowait = true,           desc = "References" },
      {
        "<C-T>",
        function()
          Snacks.picker.lsp_workspace_symbols(
            { filter = { default = true } }
          )
        end,
        desc = "LSP Workspace Symbols"
      },
      { "<C-P>",      function() Snacks.picker.files() end,                             desc = "Smart Find Files" },
      { "<leader>p",  function() Snacks.picker.files() end,                             desc = "Smart Find Files" },
      { "<leader>rf", function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent" },
      { "<leader>fa", function() Snacks.picker.grep() end,                              desc = "Grep" },
      { "<leader>fs", function() Snacks.picker.grep_word() end,                         desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>fc", function() Snacks.picker.lines() end,                             desc = "Buffer Lines" },
      { "<leader>bf", function() Snacks.picker.buffers() end,                           desc = "Buffers" },
      { "<leader>gs", function() Snacks.picker.git_status() end,                        desc = "Git Status" },
      { "<leader>gg", function() Snacks.picker.git_log() end,                           desc = "Git Log" },
      { "<leader>gl", function() Snacks.picker.git_log_line() end,                      desc = "Git Log Line" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end,                      desc = "Git Log File" },
      { "<leader>d",  function() Snacks.picker.diagnostics_buffer() end,                desc = "Buffer Diagnostics" },

      {
        "<leader>gh",
        function()
          Snacks.gitbrowse()
        end,
        desc = "git-browse",
        silent = true,
      },

      { "<C-N>", function() Snacks.explorer() end, desc = "Reveal explorer" }
    },
  },
  {
    'euclio/vim-markdown-composer',
    run = 'cargo build --release',
    config = function()
      vim.g.markdown_composer_external_renderer = 'pandoc -f markdown -t html'
      vim.g.markdown_composer_autostart = 0
    end
  },
  {
    "rjshkhr/shadow.nvim",
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
    end,
  },
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,   desc = "Flash" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    opts = {
      enabled = function()
        if vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.bo.filetype) then
          return false
        end

        local row, column = unpack(vim.api.nvim_win_get_cursor(0))
        local success, node = pcall(vim.treesitter.get_node, {
          bufnr = 0,
          pos = { row - 1, math.max(0, column - 1) } -- seems to be necessary...
        })
        if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
          return false
        end

        return vim.bo.buftype ~= 'nofile'
      end,
      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = {
          'select_next',
          'snippet_forward',
          'fallback'
        },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = { documentation = { auto_show = false } },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lsp', 'snippets', },
      },
      signature = { enabled = true, trigger = { enabled = false }, window = { winblend = 10, treesitter_highlighting = true, show_documentation = true } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      cmdline = {
        completion = {
          ghost_text = { enabled = false }
        }
      }
    },
    opts_extend = { "sources.default" },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim",        words = { "Snacks" } },
      },
    },
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
    lualine_y = {},
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
    signature = {
      enabled = false
    },
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
  notify = {
    enabled = false
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false,        -- use a classic bottom cmdline for search
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

require("luasnip.loaders.from_lua").load({ paths = "./snippets" })

local ls = require('luasnip')
ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "javascript" })

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
    -- map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>')
  end
}

require("no-neck-pain").setup({
  width = 150
})


vim.notify = function(msg, level, opts)
  if msg and string.find(msg, "multiple different client offset_encodings detected") then
    return
  end

  return require('notify').notify(msg, level, opts)
end

local jsIshFormatterOptions = { "biome", "prettier_d", "prettier" }

require("conform").setup({
  formatters = {
    biome = { require_cwd = true },
    prettier = { require_cwd = true },
    gofumpt = { require_cwd = true }
  },
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will use the first available formatter in the list
    javascript = jsIshFormatterOptions,
    typescript = jsIshFormatterOptions,
    typescriptreact = jsIshFormatterOptions,
    sass = jsIshFormatterOptions,
    scss = jsIshFormatterOptions,
    css = jsIshFormatterOptions,
    json = jsIshFormatterOptions,
    go = { "gofumpt" },
    html = { "prettier" }
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


local function virtual_text_document(params)
  local bufnr = params.buf
  local actual_path = params.match:sub(1)

  local clients = vim.lsp.get_clients({ name = "denols" })
  if #clients == 0 then
    return
  end

  local client = clients[1]
  local method = "deno/virtualTextDocument"
  local req_params = { textDocument = { uri = actual_path } }
  local response = client.request_sync(method, req_params, 2000, 0)
  if not response or type(response.result) ~= "string" then
    return
  end

  local lines = vim.split(response.result, "\n")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
  vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_buf_set_name(bufnr, actual_path)
  vim.lsp.buf_attach_client(bufnr, client.id)

  local filetype = "typescript"
  if actual_path:sub(-3) == ".md" then
    filetype = "markdown"
  end
  vim.api.nvim_set_option_value("filetype", filetype, { buf = bufnr })
end

vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
  pattern = { "deno:/*" },
  callback = virtual_text_document,
})

vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})
