local M = {}

---@class snacks.picker.treesitter.Match
---@field id string
---@field name string
---@field node TSNode
---@field text string
---@field meta table<string, any>
---@field pos {[1]: number, [2]: number}
---@field end_pos {[1]: number, [2]: number}
---@field kind? string
---@field scope? "parent" | "local" | "global"
---@field children? snacks.picker.treesitter.Match[]

-- stylua: ignore
local kind_mapping = {
  constant     = "Constant",
  type         = "Class",
  enum         = "Enum",
  field        = "Field",
  ["function"] = "Function",
  macro        = "Function",
  method       = "Method",
  namespace    = "Namespace",
  import       = "Module",
  var          = "Variable",
  -- associated = "Reference",
  parameter    = "Parameter",
}

local function sort(nodes)
  table.sort(nodes, function(a, b)
    if a.pos[1] ~= b.pos[1] then
      return a.pos[1] < b.pos[1]
    end
    if a.pos[2] ~= b.pos[2] then
      return a.pos[2] < b.pos[2]
    end
    if a.end_pos[1] ~= b.end_pos[1] then
      return a.end_pos[1] < b.end_pos[1]
    end
    return a.end_pos[2] < b.end_pos[2]
  end)
end

---@param buf number
---@return snacks.picker.treesitter.Match[]
function M.get_locals(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then
    return {}
  end
  parser:parse(true)

  local query = vim.treesitter.query.get(parser:lang(), "locals")
  if not query then
    return {}
  end

  local matches = {} ---@type snacks.picker.treesitter.Match[]

  for _, tree in ipairs(parser:trees()) do
    for id, node, meta in query:iter_captures(tree:root(), buf) do
      local name = query.captures[id]
      local kind = name:match("^local%.definition%.(.*)$")

      -- vim.print(string.format("%s => %s => %s", vim.treesitter.get_node_text(node, buf), name, kind))


      if kind then
        local range = { node:range() }
        matches[#matches + 1] = {
          id = node:id(),
          node = node,
          name = name,
          meta = meta,
          text = vim.treesitter.get_node_text(node, buf),
          pos = { range[1] + 1, range[2] },
          end_pos = { range[3] + 1, range[4] },
          kind = kind,
          scope = meta["definition.method.scope"] or "local",
        }
      end
    end
  end

  sort(matches)
  return matches
end

---@type snacks.picker.finder
function M.symbols(_, ctx)
  local buf = ctx.filter.current_buf
  local matches = M.get_locals(buf)

  local items = {} ---@type snacks.picker.finder.Item[]

  for _, match in ipairs(matches) do
    items[#items + 1] = {
      text = match.text,
      name = match.text,
      kind = kind_mapping[match.kind] or "Unknown",
      ts_kind = match.kind,
      buf = buf,
      pos = match.pos,
      end_pos = match.end_pos,
      depth = 0,
    }
  end

  return items
end

return M
