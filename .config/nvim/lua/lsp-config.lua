local navic = require 'nvim-navic'
local util = require 'lspconfig.util'
local luasnip = require 'luasnip'

-- Code action wrapper that feeds ALL line diagnostics (across every client /
-- namespace) into the request context. Native code_action only forwards the
-- invoking client's own-namespace diagnostics, which drops tsgo's pull
-- diagnostics and hides diagnostic-bound fixes like "add missing import".
local function codeAction()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.tbl_map(function(d)
    return d.user_data and d.user_data.lsp or {}
  end, vim.diagnostic.get(bufnr, { lnum = lnum }))

  vim.lsp.buf.code_action({
    context = {
      diagnostics = diagnostics,
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    },
  })
end

-- Custom QuickFix helper
local function quickFix()
  local is_first = true
  vim.lsp.buf.code_action({
    async = false,
    filter = function(action)
      if string.find(action.kind, 'suppressRule') then
        return false
      end
      if is_first then
        is_first = false
        return true
      end
      return false
    end,
    apply = true,
    context = { only = { 'quickfix' } },
  })
end

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'html',
    'vtsls',
    'eslint',
    'jsonls',
    'lua_ls',
    'cssls',
    'pyright',
    'gopls',
    'golangci_lint_ls',
    'denols',
    'stylua',
    'tailwindcss',
    'rust_analyzer',
  },
  automatic_enable = true,
})

require('fidget').setup({})

-- Global Diagnostic Config
vim.diagnostic.config({ virtual_text = false, update_in_insert = false })

-- LSP Attach Autocmd
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end
      vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
    end

    -- Mappings
    nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')

    vim.keymap.set(
      { 'n', 'v', 'x' },
      '<leader>a',
      codeAction,
      { buffer = args.buf }
    )
    nmap('gi', vim.lsp.buf.implementation, 'Goto Implementation')
    nmap('gy', vim.lsp.buf.type_definition, 'Type definition')
    nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- Navic
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, args.buf)
    end

    -- Highlights
    if client.server_capabilities.documentHighlightProvider then
      nmap('<leader>sh', vim.lsp.buf.document_highlight, 'Highlight symbol')
      nmap('<leader>ch', vim.lsp.buf.clear_references, 'Clear highlight symbol')
    end

    -- ESLint specific
    if client.name == 'eslint' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
        command = 'silent! LspEslintFixAll',
        group = vim.api.nvim_create_augroup(
          'MyAutocmdsJavaScripFormatting',
          {}
        ),
      })
    end

    -- Commands
    vim.api.nvim_buf_create_user_command(args.buf, 'Format', function(_)
      vim.lsp.buf.format({ timeout_ms = 2000 })
    end, { desc = 'Format current buffer with LSP' })

    vim.api.nvim_buf_create_user_command(
      args.buf,
      'OrganizeImports',
      function(_)
        local params = {
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = '',
        }
        vim.lsp.buf.execute_command(params)
        vim.cmd 'EslintFixAll'
      end,
      { desc = 'Organize Imports' }
    )

    -- Update on insert for specific LSPs
    if
      client.name == 'golangci_lint_ls'
      or client.name == 'gopls'
      or client.name == 'tsgolsp'
      or client.name == 'rust_analyzer'
    then
      vim.diagnostic.config({ update_in_insert = true })
    end

    if client.name == 'biome' then
      vim.diagnostic.config({ update_in_insert = true })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('BiomeFixAll', { clear = true }),
        callback = function()
          vim.lsp.buf.code_action({
            context = {
              only = { 'source.fixAll.biome' },
              diagnostics = {},
            },
            apply = true,
          })
          vim.wait(150)
        end,
      })
    end

    if client and client.name == 'cssls' then
      -- Disable the LSP document color provider
      vim.lsp.document_color.enable(false, { bufnr = args.buf })
    end
  end,
})

vim.lsp.config('denols', {
  root_markers = { 'deno.json' },
  workspace_required = true,
  settings = {
    deno = {
      enable = true,
      cacheOnSave = true,
      lint = true,
      documentPreloadLimit = 1000,
      suggest = {
        imports = {
          autoDiscover = true,
          hosts = { ['https://deno.land'] = true },
        },
      },
      testing = {
        args = { '--allow-all', '--no-check' },
      },
      unstable = true,
      codeLens = {
        implementations = false,
        references = false,
        referencesAllFunctions = false,
        test = false,
      },
    },
  },
})

vim.lsp.config('biome', {
  settings = {
    biome = { requireConfigFile = true },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      format = {
        enable = false,
        defaultConfig = {
          quote_style = 'single',
          indent_style = 'space',
          indent_size = '2',
          max_line_length = '80',
          break_table_list = 'smart',
        },
      },
    },
  },
})

vim.lsp.config('tailwindcss', {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_files = util.insert_package_json({}, 'tailwindcss', fname)
    on_dir(
      vim.fs.dirname(
        vim.fs.find(root_files, { path = fname, upward = true })[1]
      )
    )
  end,
})

vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = { command = 'clippy' },
    },
  },
})

vim.lsp.config('oxlint', {
  settings = {
    fixKind = 'all',
  },
})
vim.lsp.enable 'oxfmt'

-- Manually enabled servers (if not covered by Mason auto-enable)
vim.lsp.enable 'oxlint'
vim.lsp.enable 'tsgolsp'
vim.lsp.enable 'biome'

-- =============================================================================
-- KEYMAPS & SNIPPETS
-- =============================================================================

-- Luasnip
vim.keymap.set({ 'i' }, '<C-E>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true })

-- Diagnostics
vim.keymap.set(
  'n',
  '[d',
  '<cmd>lua vim.diagnostic.jump({count= -1, float= true})<CR>'
)
vim.keymap.set(
  'n',
  ']d',
  '<cmd>lua vim.diagnostic.jump({count= 1, float= true})<CR>'
)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- Quickfix
vim.keymap.set('n', '<leader>qf', quickFix)
vim.keymap.set('x', '<leader>qf', quickFix)

-- =============================================================================
-- CUSTOM COMMANDS
-- =============================================================================

-- VtsExec Commands
vim.api.nvim_create_user_command(
  'RemoveUnusedImports',
  ':VtsExec remove_unused_imports',
  {}
)
vim.api.nvim_create_user_command(
  'RemoveUnusedCode',
  ':VtsExec remove_unused',
  {}
)
vim.api.nvim_create_user_command(
  'AddMissingImports',
  ':VtsExec add_missing_imports',
  {}
)
vim.api.nvim_create_user_command('FixAll', ':VtsExec fix_all', {})

-- Linting Helpers
local function get_lint_cmd()
  local default_cmd =
    "npx eslint 'src/**/*.{ts,tsx}' --no-color --format stylish"
  local f = io.open('package.json', 'r')
  if f then
    local content = f:read '*a'
    f:close()
    local ok, data = pcall(vim.json.decode, content)
    if ok and data and data.scripts then
      for _, name in ipairs({ 'eslint', 'eslint-check', 'lint' }) do
        if data.scripts[name] then
          return 'npm run ' .. name .. ' -- --no-color --format stylish'
        end
      end
    end
  end
  return default_cmd
end

local spinner_frames =
  { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

-- LintProject Command
vim.api.nvim_create_user_command('LintProject', function()
  local cmd = get_lint_cmd()
  local lines = {}
  local has_notify, notify = pcall(require, 'notify')
  local notif_data = nil
  local spinner_idx = 1
  local timer = nil

  local function update_spinner()
    if not has_notify then
      return
    end
    notif_data = notify('Linting Project...', 'info', {
      title = 'ESLint',
      icon = spinner_frames[spinner_idx],
      replace = notif_data,
      hide_from_history = true,
    })
    spinner_idx = (spinner_idx % #spinner_frames) + 1
  end

  if has_notify then
    timer = vim.uv.new_timer()
    timer:start(0, 100, vim.schedule_wrap(update_spinner))
  else
    print 'Running Project Lint...'
  end

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= '' then
            table.insert(lines, line)
          end
        end
      end
    end,
    on_exit = function(_, code)
      if timer then
        timer:stop()
        timer:close()
      end

      if #lines > 0 then
        vim.fn.setqflist({}, 'r', {
          title = 'ESLint Project',
          lines = lines,
          efm = table.concat({
            '%-P%f',
            '%\\s%#%l:%c  %t%\\w%#  %m',
            '%-G%.%#',
          }, ','),
        })
      else
        vim.fn.setqflist({}, 'r')
      end

      local qf_items = vim.fn.getqflist()
      local error_count = 0
      for _, item in ipairs(qf_items) do
        if item.valid == 1 then
          error_count = error_count + 1
        end
      end

      local is_success = (code == 0) and (error_count == 0)
      local icon = is_success and '' or ''
      local level = is_success and 'info' or 'error'
      local title = 'ESLint Finished'
      local msg = is_success and 'Clean! No errors found.'
        or string.format('Found %d issues.', error_count)

      if has_notify then
        notify(msg, level, {
          title = title,
          icon = icon,
          replace = notif_data,
          timeout = 3000,
        })
      else
        print(title .. ': ' .. msg)
      end

      if error_count > 0 then
        vim.cmd 'copen'
      end
    end,
  })
end, {})

-- vim: ts=2 sts=2 sw=2 et
