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
}
