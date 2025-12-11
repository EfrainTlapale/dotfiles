local function has_tsgo()
  return vim.fn.executable('./node_modules/.bin/tsgo') == 1
end

return {
  root_dir = function(bufnr, on_dir)
    if not has_tsgo() then
      -- The project root is where the LSP can be started from
      -- As stated in the documentation above, this LSP supports monorepos and simple projects.
      -- We select then from the project root, which is identified by the presence of a package
      -- manager lock file.
      local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
      -- Give the root markers equal priority by wrapping them in a table
      root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
          or vim.list_extend(root_markers, { '.git' })

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
    javascript = {
      preferences = {
        importModuleSpecifier = "non-relative",
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
      },
    },
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
      },
    },
  },
}
