local dotenv = require 'lua-dotenv'
-- Check if file exists before loading to prevent errors
local env_path = vim.fs.normalize '~/.config/nvim/.env.local'
if vim.fn.filereadable(env_path) == 1 then
  dotenv.load_dotenv(env_path)
end

-- Load basics (options, globals) early
require 'basics'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Define Plugins
local plugins = {
  -- UI & Icons
  'kyazdani42/nvim-web-devicons',
  'MunifTanjim/nui.nvim',
  'rcarriga/nvim-notify',
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    tag = 'v3.8.2',
    opts = {
      indent = { char = { '┊' } },
      scope = { show_start = false, show_end = false, enabled = false },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    opts = {
      lsp = {
        signature = { enabled = false },
        progress = { enabled = false },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      messages = {
        enabled = false,
        view = 'cmdline_output',
        view_search = false,
      },
      notify = { enabled = false },
      popupmenu = { enabled = true },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  -- Navigation & Telescope
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  'prochri/telescope-all-recent.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'benfowler/telescope-luasnip.nvim',

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  'nvim-treesitter/nvim-treesitter-textobjects',
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('ts_context_commentstring').setup({ enable_autocmd = false })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    opts = { auto_close_on_slash = true },
  },

  -- Editing & Utilities
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'f-person/git-blame.nvim',
    opts = { enabled = false }, -- Explicitly disable as per your original config
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'sindrets/diffview.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'shortcuts/no-neck-pain.nvim',
    version = '*',
    opts = { width = 150 },
  },
  'kkharji/sqlite.lua',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        preview_config = { border = 'rounded' },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          map({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
          map({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function()
            gs.blame_line({ full = true })
          end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map({ 'o', 'x' }, 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>')
        end,
      })
    end,
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        pre_hook = require(
          'ts_context_commentstring.integrations.comment_nvim'
        ).create_pre_hook(),
      })
    end,
  },
  { 'm4xshen/autoclose.nvim', opts = {} },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      direction = 'horizontal',
      terminal_mappings = true,
      close_on_exit = true,
      size = 18,
      float_opts = {
        border = 'curved',
        width = 180,
        height = 40,
        winblend = 3,
      },
    },
  },
  {
    'JellyApple102/flote.nvim',
    config = function()
      require('flote').setup({
        window_border = 'single',
        files = {
          cwd = function()
            local bufPath = vim.api.nvim_buf_get_name(0)
            return require('lspconfig').util.root_pattern '.git'(bufPath)
          end,
        },
      })
    end,
  },

  -- LSP & Completion
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
    },
  },
  { 'SmiteshP/nvim-navic', dependencies = 'neovim/nvim-lspconfig' },
  { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' },
  'liangxianzhe/floating-input.nvim',
  'RishabhRD/popfix',
  'RishabhRD/nvim-lsputils',
  { 'dmmulroy/tsc.nvim', version = 'v1.6.0', opts = {} },

  -- Formatting
  {
    'stevearc/conform.nvim',
    opts = {
      formatters = {
        biome = { require_cwd = true },
        prettier = { require_cwd = true },
        gofumpt = { require_cwd = true },
        ruff_format = {
          command = 'docker',
          args = {
            'exec',
            'django-app-my-server',
            'ruff',
            'format',
            '$RELATIVE_FILEPATH',
          },
          stdin = false,
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'biome', 'prettier_d', 'prettier' },
        typescript = { 'biome', 'prettier_d', 'prettier' },
        typescriptreact = { 'biome', 'prettier_d', 'prettier' },
        json = { 'biome', 'prettier_d', 'prettier' },
        go = { 'gofumpt' },
        html = { 'prettier' },
        markdown = { 'prettier' },
        python = { 'ruff_format' },
        yaml = { 'prettier' },
      },
      format_on_save = { timeout_ms = 10000, lsp_fallback = true },
    },
  },

  -- Snippets (Needed for Blink/CMP)
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    config = function()
      require('luasnip.loaders.from_lua').load({ paths = './snippets' })
      local ls = require 'luasnip'
      ls.filetype_extend('typescript', { 'javascript' })
      ls.filetype_extend('typescriptreact', { 'javascript' })
    end,
  },
  -- 'saadparwaiz1/cmp_luasnip',

  -- Autocompletion: BLINK (replaces nvim-cmp)
  -- NOTE: I removed hrsh7th/nvim-cmp as it conflicts with blink.cmp
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      enabled = function()
        if vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.bo.filetype) then
          return false
        end

        local row, column = unpack(vim.api.nvim_win_get_cursor(0))
        local success, node = pcall(vim.treesitter.get_node, {
          bufnr = 0,
          pos = { row - 1, math.max(0, column - 1) }, -- seems to be necessary...
        })
        if
          success
          and node
          and vim.tbl_contains(
            { 'comment', 'line_comment', 'block_comment' },
            node:type()
          )
        then
          return false
        end

        return vim.bo.buftype ~= 'nofile'
      end,
      keymap = {
        preset = 'none',
        ['<C-space>'] = {
          'show',
          'show_documentation',
          'hide_documentation',
        },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = {
          'select_next',
          'snippet_forward',
          'fallback',
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
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = {
          auto_show = false,
        },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
      },
      sources = {
        default = { 'lsp' },
      },
      snippets = { preset = 'luasnip' },
      signature = {
        enabled = true,
        trigger = { enabled = false },
        window = {
          winblend = 10,
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      cmdline = {
        enabled = true,
        completion = {
          ghost_text = { enabled = false },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },

  -- Languages & HTTP
  'yioneko/nvim-vtsls',
  {
    'mistweaverco/kulala.nvim',
    opts = {},
    ft = { 'http', 'rest' },
    keys = {
      { '<CR>', "<cmd>lua require('kulala').run()<CR>", ft = 'http' },
      { '[r', "<cmd>lua require('kulala').jump_prev()<CR>", ft = 'http' },
      { ']r', "<cmd>lua require('kulala').jump_next()<CR>", ft = 'http' },
      {
        '<leader>ci',
        "<cmd>lua require('kulala').from_curl()<CR>",
        ft = 'http',
      },
      {
        '<leader>co',
        "<cmd>lua require('kulala').copy()<CR>",
        ft = 'http',
      },
      {
        '<leader>o',
        "<cmd>lua require('kulala').search()<CR>",
        ft = 'http',
      },
      {
        '<leader>ck',
        "<cmd>lua require('kulala').close()<CR>",
        ft = 'http',
      },
    },
  },
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    keys = {
      {
        '<leader>q',
        function()
          require('quicker').toggle()
        end,
        desc = 'Toggle quickfix',
      },
      {
        '>',
        function()
          require('quicker').expand({
            before = 2,
            after = 2,
            add_to_existing = true,
          })
        end,
        desc = 'Expand quickfix context',
        ft = 'qf',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
        ft = 'qf',
      },
    },
    opts = { edit = { enabled = false } },
  },
  { 'mawkler/refjump.nvim', opts = {} },
  {
    'kvrohit/rasmus.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd([[colorscheme rasmus]])
    end,
  },
  {
    'S1M0N38/love2d.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { '<leader>v', ft = 'lua', desc = 'LÖVE' },
      {
        '<leader>vv',
        '<cmd>LoveRun<cr>',
        ft = 'lua',
        desc = 'Run LÖVE',
      },
      {
        '<leader>vs',
        '<cmd>LoveStop<cr>',
        ft = 'lua',
        desc = 'Stop LÖVE',
      },
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = true,
  },

  -- Themes
  {
    'neanias/everforest-nvim',
    lazy = false,
    config = function()
      require('everforest').setup({
        background = 'hard',
        disable_italic_comments = true,
        on_highlights = function(hl, palette)
          hl.NonText = { fg = '#859289' }
        end,
      })
    end,
  },
  'aktersnurra/no-clown-fiesta.nvim',
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
  'EdenEast/nightfox.nvim',
  'shaunsingh/nord.nvim',
  'nyoom-engineering/oxocarbon.nvim',
  'navarasu/onedark.nvim',
  'rebelot/kanagawa.nvim',
  'vague-theme/vague.nvim',
  { 'e-q/okcolors.nvim', name = 'okcolors' },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        sections = {
          { section = 'header' },
          {
            icon = ' ',
            title = 'Recent Files',
            section = 'recent_files',
            cwd = true,
          },
          { section = 'startup' },
        },
      },
      explorer = {
        replace_netrw = true,
      },
      picker = {
        toggles = { hidden = false },
        icons = {
          kinds = {
            Parameter = '󰅲',
            Variable = '',
            Property = '',
          },
        },
        layout = 'dropdown',
        ui_select = false,
        sources = {
          explorer = {
            jump = {
              close = true,
            },
            enter = true,
            win = {
              list = {
                keys = {
                  ['<c-n>'] = { 'close', mode = { 'i', 'n' } },
                  ['<CR>'] = {
                    { 'pick_win', 'jump' },
                    mode = { 'n', 'i' },
                  },
                },
              },
            },
          },
        },
        matcher = {
          frecency = true,
          fuzzy = true,
        },
        win = {
          input = {
            keys = {
              ['<c-d>'] = {
                'preview_scroll_down',
                mode = { 'i', 'n' },
              },
              ['<c-u>'] = {
                'preview_scroll_up',
                mode = { 'i', 'n' },
              },
            },
          },
        },
        formatters = {
          file = { truncate = 60, filename_first = true },
        },
      },
      gitbrowse = {},
    },
    keys = {
      {
        '<leader>o',
        function()
          local picker = require 'snacks.picker'
          local tspicker = require 'customTsPicker'

          picker.pick({
            finder = tspicker.symbols,
            format = 'lsp_symbol',
            title = 'Treesitter',
          })
        end,
        desc = 'LSP Symbols',
      },
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = 'Goto Definition',
      },
      {
        'gr',
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = 'References',
      },
      {
        '<C-T>',
        function()
          Snacks.picker.lsp_workspace_symbols({
            filter = { default = true },
          })
        end,
        desc = 'LSP Workspace Symbols',
      },
      {
        '<C-P>',
        function()
          Snacks.picker.files({
            hidden = true,
            layout = { preset = 'vscode' },
          })
        end,
        desc = 'Smart Find Files',
      },
      {
        '<leader>p',
        function()
          Snacks.picker.files({
            hidden = true,
            layout = { preset = 'vscode' },
          })
        end,
        desc = 'Smart Find Files',
      },
      {
        '<leader>rf',
        function()
          Snacks.picker.recent({
            hidden = true,
            filter = { cwd = true },
            layout = { preset = 'vscode' },
          })
        end,
        desc = 'Recent',
      },
      {
        '<leader>fa',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>fs',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Visual selection or word',
        mode = { 'n', 'x' },
      },
      {
        '<leader>fc',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>bf',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>gs',
        function()
          Snacks.picker.git_status({ layout = { preset = 'default' } })
        end,
        desc = 'Git Status',
      },
      {
        '<leader>gg',
        function()
          Snacks.picker.git_log()
        end,
        desc = 'Git Log',
      },
      {
        '<leader>gl',
        function()
          Snacks.picker.git_log_line()
        end,
        desc = 'Git Log Line',
      },
      {
        '<leader>gf',
        function()
          Snacks.picker.git_log_file()
        end,
        desc = 'Git Log File',
      },
      {
        '<leader>dd',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = 'Buffer Diagnostics',
      },
      {
        '<leader>k',
        function()
          Snacks.picker.pickers()
        end,
        desc = 'Pickers',
      },
      {
        '<leader>hh',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command history',
      },

      {
        '<leader>gh',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'git-browse',
        silent = true,
      },

      {
        '<C-N>',
        function()
          Snacks.explorer()
        end,
        desc = 'Reveal explorer',
      },
    },
  },
  {
    'euclio/vim-markdown-composer',
    build = 'cargo build --release',
    config = function()
      vim.g.markdown_composer_external_renderer = 'pandoc -f markdown -t html'
      vim.g.markdown_composer_autostart = 0
    end,
  },
  {
    'rjshkhr/shadow.nvim',
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
    end,
  },
  { 'webhooked/kanso.nvim', lazy = false, priority = 1000 },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        'ss',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
  {
    'khoido2003/monokai-v2.nvim',
    priority = 1000,
    config = function()
      require('monokai-v2').setup({ filter = 'machine' })
    end,
  },
  'armannikoyan/rusty',
  { 'dgox16/oldworld.nvim', lazy = false, priority = 1000 },
  { 'slugbyte/lackluster.nvim', lazy = false, priority = 1000 },
  {
    'eero-lehtinen/oklch-color-picker.nvim',
    event = 'VeryLazy',
    version = '*',
    opts = {},
  },
  { 'bngarren/checkmate.nvim', ft = 'markdown', opts = {} },
  { 'nendix/zen.nvim', lazy = false, priority = 1000 },
  {
    'esmuellert/vscode-diff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
  },
}

-- Setup lazy.nvim
require('lazy').setup({
  spec = plugins,
  install = { colorscheme = { 'habamax' } },
})

-- == POST-PLUGIN LOADS ==

-- These requires need to happen after plugins are installed/loaded
require 'colors'
require 'telescope-config'
require 'lsp-config' -- Ensure this file sets up Mason and LSPConfig using the plugins installed above
require('vtsls').config({})
require('quickrun').setup()

-- Lualine setup after colorscheme is set so that auto theme works

local auto = require 'lualine.themes.auto'
if vim.g.colors_name == 'efra-2' then
  auto.visual.a.bg = '#A68CB3'
end

require('lualine').setup({
  options = {
    section_separators = { left = '', right = '' },
    theme = auto,
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'diff', 'diagnostics' },
    lualine_c = { 'filename', 'navic' },
    lualine_x = { 'filetype' },
    lualine_y = {},
    lualine_z = {
      {
        'location',
        separator = { right = '', left = '' },
        left_padding = 2,
      },
    },
  },
  tabline = {
    lualine_c = { 'branch', 'tabs' },
  },
})

-- == CUSTOM COMMANDS & AUTOCMDS ==

vim.api.nvim_create_user_command(
  'RunTests',
  ':<cmd>TermExec cmd="./run_tests_local.sh" direction="vertical" size=80',
  {}
)
vim.api.nvim_create_user_command(
  'DismissNotifications',
  ":lua require('notify').dismiss()",
  {}
)

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
  pattern = '.env*',
  command = 'set filetype=bash',
})

vim.filetype.add({
  extension = { ['http'] = 'http' },
})

-- Custom Notify wrapper
vim.notify = function(msg, level, opts)
  if
    msg
    and (
      string.find(msg, 'multiple different client offset_encodings detected')
      or string.find(msg, 'No code actions available')
    )
  then
    return
  end
  return require('notify').notify(msg, level, opts)
end

-- == DENO VIRTUAL TEXT SETUP ==
-- Encapsulated nicely to avoid polluting global scope
local function setup_deno_virtual_text()
  local function virtual_text_document(params)
    local bufnr = params.buf
    local actual_path = params.match:sub(1)
    local clients = vim.lsp.get_clients({ name = 'denols' })
    if #clients == 0 then
      return
    end

    local client = clients[1]
    local method = 'deno/virtualTextDocument'
    local req_params = { textDocument = { uri = actual_path } }
    local response = client.request_sync(method, req_params, 2000, 0)

    if not response or type(response.result) ~= 'string' then
      return
    end

    local lines = vim.split(response.result, '\n')
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
    vim.api.nvim_set_option_value('modified', false, { buf = bufnr })
    vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
    vim.api.nvim_buf_set_name(bufnr, actual_path)
    vim.lsp.buf_attach_client(bufnr, client.id)

    local filetype = (actual_path:sub(-3) == '.md') and 'markdown'
      or 'typescript'
    vim.api.nvim_set_option_value('filetype', filetype, { buf = bufnr })
  end

  vim.api.nvim_create_autocmd({ 'BufReadCmd' }, {
    pattern = { 'deno:/*' },
    callback = virtual_text_document,
  })
end

setup_deno_virtual_text()
