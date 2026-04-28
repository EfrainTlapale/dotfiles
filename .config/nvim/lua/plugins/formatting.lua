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
      javascript = { 'biome', 'prettier_d', 'prettier' },
      typescript = { 'biome', 'prettier_d', 'prettier' },
      typescriptreact = { 'biome', 'prettier_d', 'prettier' },
      json = { 'biome', 'prettier_d', 'prettier' },
      go = { 'gofumpt' },
      html = { 'prettier' },
      markdown = { 'prettier' },
      python = { 'ruff_format' },
      yaml = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
    },
    format_on_save = { timeout_ms = 10000, lsp_format = false },
  },
}
