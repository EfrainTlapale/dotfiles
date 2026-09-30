-- Fallback for projects without a local TypeScript 7 (see after/lsp/tsc.lua)
local ts_native = require 'ts-native'

return {
  root_dir = function(bufnr, on_dir)
    if ts_native.is_deno(bufnr) or ts_native.find(bufnr) then
      return
    end

    -- We fallback to the current working directory if no project root is found
    on_dir(vim.fs.root(bufnr, { 'tsconfig.json' }) or vim.fn.getcwd())
  end,
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
    javascript = {
      preferences = {
        importModuleSpecifier = 'non-relative',
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
      },
    },
    typescript = {
      preferences = {
        importModuleSpecifier = 'non-relative',
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
      },
    },
  },
}
