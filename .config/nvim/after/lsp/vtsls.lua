local function has_tsgo()
  -- also covers typescript 7 installed under an alias, e.g. "typescript7": "npm:typescript@7"
  return vim.fn.executable './node_modules/.bin/tsgo' == 1
    or vim.fn.executable './node_modules/typescript7/bin/tsc' == 1
end

return {
  root_dir = function(bufnr, on_dir)
    if not has_tsgo() then
      local root_markers = { 'tsconfig.json' }
      -- exclude deno
      if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
        return
      end

      -- We fallback to the current working directory if no project root is found
      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

      on_dir(project_root)
    end
  end,
  root_markers = { 'tsconfig.json', 'package.json' },
  workspace_required = true,
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
