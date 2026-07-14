---Line range of the active visual selection, or nil when not in visual mode.
---Exits visual mode so the picker doesn't open on top of the selection.
---@return {[1]: number, [2]: number}?
local function visual_selection_lines()
  if not vim.fn.mode():match '^[vV\22]' then
    return nil
  end

  local first, last = vim.fn.getpos('v')[2], vim.fn.getpos('.')[2]
  if first > last then
    first, last = last, first
  end

  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'nx', false)

  return { first, last }
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    terminal = { auto_insert = false },
    dashboard = {
      sections = {
        { section = 'header' },
        {
          icon = ' ',
          title = 'Recent Files',
          section = 'recent_files',
          cwd = true,
        },
        { section = 'startup' },
      },
    },
    explorer = {
      replace_netrw = true,
    },
    picker = {
      toggles = { hidden = false },
      icons = {
        kinds = {
          Parameter = '󰅲',
          Variable = '',
          Property = '',
        },
      },
      layout = 'dropdown',
      ui_select = false,
      sources = {
        explorer = {
          jump = {
            close = true,
          },
          enter = true,
          win = {
            list = {
              keys = {
                ['<c-n>'] = { 'close', mode = { 'i', 'n' } },
                ['<CR>'] = {
                  { 'pick_win', 'jump' },
                  mode = { 'n', 'i' },
                },
              },
            },
          },
        },
      },
      matcher = {
        frecency = true,
        fuzzy = true,
      },
      win = {
        input = {
          keys = {
            ['<c-d>'] = {
              'preview_scroll_down',
              mode = { 'i', 'n' },
            },
            ['<c-u>'] = {
              'preview_scroll_up',
              mode = { 'i', 'n' },
            },
          },
        },
      },
      formatters = {
        file = { truncate = 60, filename_first = true },
      },
    },
    gitbrowse = {},
  },
  keys = {
    {
      '<leader>o',
      function()
        -- with an active visual selection, only show symbols inside it
        local range = visual_selection_lines()

        require('snacks.picker').pick({
          finder = require('customTsPicker').symbols,
          format = 'lsp_symbol',
          title = range and 'Treesitter (selection)' or 'Treesitter',
          range = range,
        })
      end,
      mode = { 'n', 'x' },
      desc = 'LSP Symbols',
    },
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      '<C-T>',
      function()
        Snacks.picker.lsp_workspace_symbols({
          filter = { default = true },
        })
      end,
      desc = 'LSP Workspace Symbols',
    },
    {
      '<C-P>',
      function()
        Snacks.picker.files({
          hidden = true,
          layout = { preset = 'vscode' },
        })
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>p',
      function()
        local items = {}
        for _, item in ipairs(require('yanky.history').all()) do
          local text = type(item.regcontents) == 'table'
              and table.concat(item.regcontents, '\n')
            or item.regcontents
          table.insert(items, { text = text, regtype = item.regtype })
          if #items >= 10 then
            break
          end
        end
        vim.ui.select(items, {
          prompt = 'Yank History',
          format_item = function(item)
            return item.text:gsub('\n', '⏎')
          end,
        }, function(choice)
          if choice then
            vim.fn.setreg('"', choice.text, choice.regtype)
            vim.api.nvim_feedkeys('p', 'n', false)
          end
        end)
      end,
      desc = 'Yank History',
    },
    {
      '<leader>rf',
      function()
        Snacks.picker.recent({
          hidden = true,
          filter = { cwd = true },
          layout = { preset = 'vscode' },
        })
      end,
      desc = 'Recent',
    },
    {
      '<leader>fa',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>fs',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>fc',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>bf',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status({ layout = { preset = 'default' } })
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gg',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
    },
    {
      '<leader>dd',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader>k',
      function()
        Snacks.picker.pickers()
      end,
      desc = 'Pickers',
    },
    {
      '<leader>hh',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command history',
    },

    {
      '<leader>gh',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'git-browse',
      silent = true,
    },

    {
      '<C-N>',
      function()
        Snacks.explorer()
      end,
      desc = 'Reveal explorer',
    },
  },
}
