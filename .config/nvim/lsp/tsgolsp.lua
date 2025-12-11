-- Try running "npx tsgo --version"
local function has_tsgo()
  return vim.fn.executable("./node_modules/.bin/tsgo") == 1
end

---@type vim.lsp.Config
return {
  cmd = { 'npx', 'tsgo', '--lsp', '--stdio' },
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
