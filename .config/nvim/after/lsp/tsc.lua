-- Merged on top of nvim-lspconfig's `tsc` (TypeScript 7 native LSP).
-- Only attaches when the project has TS7 installed locally; otherwise vtsls
-- takes over (see after/lsp/vtsls.lua). Never falls back to a global `tsc`.
local ts_native = require 'ts-native'

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local native = assert(ts_native.find(config.root_dir))
    return vim.lsp.rpc.start(
      { native.bin, '--lsp', '--stdio' },
      dispatchers,
      { cwd = config.root_dir }
    )
  end,
  root_dir = function(bufnr, on_dir)
    if ts_native.is_deno(bufnr) then
      return
    end

    local native = ts_native.find(bufnr)
    if native then
      on_dir(native.root)
    end
  end,
  init_options = {
    preferences = {
      preferTypeOnlyAutoImports = true,
    },
  },
  settings = {
    typescript = { preferences = { preferTypeOnlyAutoImports = true } },
    javascript = { preferences = { preferTypeOnlyAutoImports = true } },
  },
}
