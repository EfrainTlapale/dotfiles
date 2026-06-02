local jsish = { 'oxfmt', 'biome', 'prettier_d', 'prettier' }
return {
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
      javascript = jsish,
      typescript = jsish,
      typescriptreact = jsish,
      json = jsish,
      go = { 'gofumpt' },
      html = jsish,
      markdown = jsish,
      python = { 'ruff_format' },
      yaml = jsish,
      css = jsish,
      scss = jsish,
    },
    format_on_save = { timeout_ms = 10000, lsp_format = false },
  },
}
