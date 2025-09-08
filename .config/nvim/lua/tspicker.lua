local M = {}

---@type snacks.picker.finder
function M.provider_symbols(_, ctx)
  local buf = ctx.filter.current_buf
  local ft = vim.bo[buf].filetype
  local lang = require("nvim-treesitter.parsers").ft_to_lang(ft)

  local ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
  if not ok or not parser then return {} end

  local tree = parser:parse()[1]
  local root = tree:root()

  local q_ok, query = pcall(vim.treesitter.query.get, lang, "locals")
  if not q_ok or not query then return {} end

  -- 🎯 Only one central kind mapping now
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
    associated   = "Reference",
    parameter    = "Parameter",
    property     = "Property"
  }

  local rules = {
    vstls = {
      lookups = {
        reference = {
          identifier = {
            var = { "array_pattern", "shorthand_property_identifier" }
          },
          type_identifier = {
            type = { "type_annotation" }
          }
        },
        definition = {
          identifier = {
            parameter = { "required_parameter", "optional_parameter", "shorthand_property_identifier" },
          }
        }
      },
    },
  }

  local function find_parent_match(node, parents)
    local p = node:parent()
    while p do
      if vim.tbl_contains(parents, p:type()) then return true end
      p = p:parent()
    end
    return false
  end

  local items = {}

  for id, node in query:iter_captures(root, buf, 0, -1) do
    local capture = query.captures[id]
    local text = vim.treesitter.get_node_text(node, buf) or "<anonymous>"
    local row, col = node:range()
    local node_type = node:type()

    for provider, cfg in pairs(rules) do
      local section, subkind = capture:match("^locals?%.([^.]+)%.?(.*)$")

      -- if string.find(text, "Props") then
      --   vim.print(string.format("text:%s capture:%s section:%s subkind:%s type:%s parentT:%s", string.sub(text, 0, 50),
      --     capture, section,
      --     subkind,
      --     node_type, node:parent():type()))
      -- end

      -- Step 1: Direct match using subkind → kind_mapping
      if section and subkind and subkind ~= "" then
        local kind = kind_mapping[subkind]
        if kind then
          table.insert(items, {
            text = string.format("[%s:%s] %s (%s)", provider, kind, text, node_type),
            name = text,
            kind = kind,
            ts_kind = subkind,
            pos = { row + 1, col + 1 },
            end_pos = { row + 1, col + 1 },
            buf = buf,
            depth = 0,
            last = true,
          })
          break
        end
      end

      -- Step 2: Lookup fallback
      if section and (not subkind or subkind == "") then
        local section_lookup = cfg.lookups[section]
        if section_lookup then
          local node_rules = section_lookup[node_type]
          if node_rules then
            for label, parents in pairs(node_rules) do
              if vim.tbl_contains(parents, node:type()) or find_parent_match(node, parents) then
                local kind = kind_mapping[label]
                if kind then
                  table.insert(items, {
                    text = string.format("[%s:%s] %s (%s)", provider, kind, text, node_type),
                    name = text,
                    kind = kind,
                    ts_kind = label,
                    pos = { row + 1, col + 1 },
                    end_pos = { row + 1, col + 1 },
                    buf = buf,
                    depth = 0,
                    last = true,
                  })
                end
                break
              end
            end
          end
        end
      end
    end
  end

  return items
end

return M
