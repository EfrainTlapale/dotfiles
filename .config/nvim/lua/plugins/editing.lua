local width = math.floor(vim.o.columns * 0.6)
local height = math.floor(vim.o.lines * 0.4)

return {
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'shortcuts/no-neck-pain.nvim',
    version = '*',
    opts = { width = 150 },
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
  {
    'm4xshen/autoclose.nvim',
    opts = {
      keys = {
        ["'"] = { disabled_filetypes = { 'rust' } },
      },
    },
  },
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
        width = width,
        height = height,
        -- row = (vim.o.lines - height) / 2,
        -- col = (vim.o.columns - width) / 2,
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
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        search = { enabled = false },
        char = { enabled = false },
      },
    },
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
    'eero-lehtinen/oklch-color-picker.nvim',
    event = 'VeryLazy',
    version = '*',
    opts = {
      highlight = {
        enabled = false,
      },
    },
  },
  { 'nendix/zen.nvim', lazy = false, priority = 1000 },
  {
    'Goose97/timber.nvim',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('timber').setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    'gbprod/yanky.nvim',
    event = 'TextYankPost',
    dependencies = {
      { 'kkharji/sqlite.lua' },
    },
    keys = {
      {
        'p',
        function()
          require('yanky-cycle').put 'p'
        end,
        mode = { 'n', 'x' },
        desc = 'Paste (yanky)',
      },
      {
        'P',
        function()
          require('yanky-cycle').put 'P'
        end,
        mode = { 'n', 'x' },
        desc = 'Paste before (yanky)',
      },
      {
        'gp',
        function()
          require('yanky-cycle').put 'gp'
        end,
        mode = { 'n', 'x' },
        desc = 'Paste after (gp)',
      },
      {
        'gP',
        function()
          require('yanky-cycle').put 'gP'
        end,
        mode = { 'n', 'x' },
        desc = 'Paste before (gP)',
      },
      {
        ']p',
        function()
          require('yanky-cycle').put ']p'
        end,
        mode = { 'n', 'x' },
        desc = 'Paste indent after',
      },
      {
        '[p',
        function()
          require('yanky-cycle').put '[p'
        end,
        mode = { 'n', 'x' },
        desc = 'Paste indent before',
      },
    },
    opts = {
      ring = { storage = 'sqlite' },
      highlight = {
        on_put = false,
        on_yank = false,
      },
    },
    config = function(_, opts)
      require('yanky').setup(opts)
      require('yanky-cycle').setup({ timeout_ms = 2000 })
    end,
  },
}
