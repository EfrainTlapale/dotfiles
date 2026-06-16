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
        local picker = require 'snacks.picker'
        local tspicker = require 'customTsPicker'

        picker.pick({
          finder = tspicker.symbols,
          format = 'lsp_symbol',
          title = 'Treesitter',
        })
      end,
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
        Snacks.picker.pick({
          title = 'Yank History',
          finder = function()
            local items = {}
            for i, item in ipairs(require('yanky.history').all()) do
              local text = type(item.regcontents) == 'table'
                  and table.concat(item.regcontents, '\n')
                or item.regcontents
              table.insert(items, {
                idx = i,
                text = text,
                regtype = item.regtype,
                preview = { text = text, ft = 'text' },
              })
            end
            return items
          end,
          format = function(item)
            return { { (item.text:gsub('\n', '⏎')), 'SnacksPickerLabel' } }
          end,
          preview = 'preview',
          confirm = function(picker, item)
            picker:close()
            if item then
              vim.fn.setreg('"', item.text, item.regtype)
              vim.api.nvim_feedkeys('p', 'n', false)
            end
          end,
        })
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
