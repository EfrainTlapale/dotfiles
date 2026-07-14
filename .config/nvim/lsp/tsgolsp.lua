-- typescript 7 installed under an alias, e.g. "typescript7": "npm:@typescript/native-preview"
local tsc7 = './node_modules/typescript7/bin/tsc'

local function has_tsc7()
  return vim.fn.executable(tsc7) == 1
end

-- Try running "npx tsgo --version"
local function has_tsgo()
  return vim.fn.executable './node_modules/.bin/tsgo' == 1 or has_tsc7()
end

---@type vim.lsp.Config
return {
  cmd = has_tsc7() and { tsc7, '--lsp', '--stdio' } or { 'npx', 'tsgo', '--lsp', '--stdio' },
  init_options = {
    preferences = {
      preferTypeOnlyAutoImports = true,
    },
  },
  settings = {
    typescript = { preferences = { preferTypeOnlyAutoImports = true } },
    javascript = { preferences = { preferTypeOnlyAutoImports = true } },
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    if has_tsgo() then
      -- exclude deno
      if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
        return
      end

      local project_root = vim.fs.root(bufnr, { 'tsconfig.json', '.git' })

      on_dir(project_root)
    end
  end,
}
