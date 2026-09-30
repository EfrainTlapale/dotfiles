-- Detects a project-local TypeScript 7 (native) compiler, so `tsc --lsp` is
-- used where it's installed and vtsls everywhere else.
--
-- Recommended side-by-side setup (TS7 for the editor/typecheck, TS6 for
-- typescript-eslint and other API consumers):
--
--   "@typescript/native": "npm:typescript@^7",
--   "typescript": "npm:@typescript/typescript6@^6"
--
-- `tsc` is then v7 and `tsc6` is v6. Since `tsc` can also be v5/v6, candidates
-- are checked by the version in their package.json, not just by existence.
local M = {}

-- Relative to each node_modules dir, in priority order
local candidates = {
  '@typescript/native/bin/tsc', -- side-by-side alias from the TS7 announcement
  '.bin/tsc', -- plain typescript@7
  '.bin/tsgo', -- legacy @typescript/native-preview
}

---@param bin string
---@return boolean
local function is_native(bin)
  local real = vim.uv.fs_realpath(bin)
  if not real or vim.fn.executable(real) ~= 1 then
    return false
  end

  local pkg_dir = vim.fs.root(real, 'package.json')
  if not pkg_dir then
    return false
  end

  local ok, pkg = pcall(function()
    local lines = vim.fn.readfile(vim.fs.joinpath(pkg_dir, 'package.json'))
    return vim.json.decode(table.concat(lines, '\n'))
  end)
  local version = ok and pkg.version and vim.version.parse(pkg.version)

  return version ~= nil and version.major >= 7
end

--- Walks up from `source` (buffer or path) like node resolution does and
--- returns the nearest native TS compiler plus the dir holding its node_modules.
---@param source integer|string
---@return { root: string, bin: string }?
function M.find(source)
  local path = type(source) == 'number' and vim.api.nvim_buf_get_name(source)
    or source --[[@as string]]
  if path == '' then
    path = vim.fn.getcwd()
  end

  local start = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
  local dirs = { start }
  vim.list_extend(dirs, vim.iter(vim.fs.parents(start)):totable())

  for _, dir in ipairs(dirs) do
    local node_modules = vim.fs.joinpath(dir, 'node_modules')
    if vim.fn.isdirectory(node_modules) == 1 then
      for _, rel in ipairs(candidates) do
        local bin = vim.fs.joinpath(node_modules, rel)
        if is_native(bin) then
          return { root = dir, bin = bin }
        end
      end
    end
  end
end

--- True when the buffer belongs to a Deno project (denols handles those).
---@param bufnr integer
---@return boolean
function M.is_deno(bufnr)
  return vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) ~= nil
end

return M
