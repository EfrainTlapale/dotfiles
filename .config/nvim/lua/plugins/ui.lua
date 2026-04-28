return {
  'kyazdani42/nvim-web-devicons',
  'MunifTanjim/nui.nvim',
  'rcarriga/nvim-notify',
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
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    opts = {
      lsp = {
        signature = { enabled = false },
        progress = { enabled = false },
        hover = { silent = true },
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
}
