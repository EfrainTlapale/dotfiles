local navic = require("nvim-navic")

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
local function tprint(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent + 1)
    else
      print(formatting .. tostring(v))
    end
  end
end

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "typescript", "css", "scss", "javascript", "markdown",
    "markdown_inline", "python", "tsx", "bash", "fish", "json", "http" },
  highlight = {
    enable = true,
  },
  auto_install = true,
  indent = { enable = true },
  autotag = { enable = true, enable_close_on_slash = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-s>',
      node_incremental = '<c-s>',
      -- scope_incremental = '<c-s>',
      -- node_decremental = '<c-S>',
    },
  },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = '@function.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
      }
    },
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      }
    }
  }
}

-- LSP settings.
vim.diagnostic.config({ virtual_text = false, update_in_insert = false })

local cos = require("codeactions-on-save")

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>a', vim.lsp.buf.code_action, 'Action')
  vim.keymap.set('x', '<leader>a', vim.lsp.buf.code_action, { buffer = bufnr })

  nmap('gd', function() require('telescope.builtin').lsp_definitions() end, 'Goto Definition')
  nmap('gr',
    function()
      require('telescope.builtin').lsp_references({
        include_declaration = false,
        -- path_display = { "tail" },
        show_line = false,
        layout_config = { preview_width = 0.6 }
      })
    end, 'Goto References')
  nmap('gi', vim.lsp.buf.implementation, 'Goto Implementation')
  nmap('gy', vim.lsp.buf.type_definition, 'Type definition')
  nmap('<leader>o', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
  nmap('<C-T>', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
  nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  if client.server_capabilities.documentHighlightProvider then
    nmap('<leader>sh', vim.lsp.buf.document_highlight, 'Highlight symbol')
    nmap('<leader>ch', vim.lsp.buf.clear_references, 'Clear highlight symbol')
  end

  if client.name == 'eslint' then
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
      command = 'silent! EslintFixAll',
      group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
    })
  end

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_buf_create_user_command(bufnr, 'OrganizeImports', function(_)
    local params = {
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = "",
    }
    vim.lsp.buf.execute_command(params)
    vim.cmd('EslintFixAll')
  end, { desc = 'Organize Imports' })

  if client.name == 'biome' then
    vim.diagnostic.config({ update_in_insert = true })
    cos.register({ "*.ts", "*.tsx" }, { "source.organizeImports.biome" })
  end
end

local servers = {
  vtsls = {
    typescript = { tsserver = { maxTsServerMemory = 8192 } },
    vtsls = {
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = { enableServerSideFuzzyMatch = true, entriesLimit = 30 } }
    }
  },
  eslint = {},
  jsonls = {},
  biome = {
    biome = {
      requireConfigFile = true
    },
  },
  lua_ls = {},
  cssls = {},
  pyright = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true
      }
    }
  }
}

--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    --  TEMP PATCH: fixme after mason thingy is updated
    if server_name == "tsserver" then
      server_name = "ts_ls"
    end
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- require("luasnip.loaders.from_vscode").lazy_load()
local ls = require("luasnip")
vim.keymap.set({ "i" }, "<C-K>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- Turn on lsp status information
require('fidget').setup({})

-- nvim-cmp setup
local cmp = require 'cmp'

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  matching = {
    disallow_fuzzy_matching = false,
    disallow_fullfuzzy_matching = false,
    disallow_partial_fuzzy_matching = false,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = false,
  },
}


local function quickFix()
  local is_first = true
  -- Filter actions by _typescipr/workspace_edit or eslint.applySuggestion to mimic coc code action
  -- generaly the first option is the common fix, so for quickfix we filter just the first one
  -- and apply it
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
    context = { only = { 'quickfix' } }
  })
end

-- Additional kepmaps

vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.jump({count= -1, float= true})<CR>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.jump({count= 1, float= true})<CR>')
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>qf', quickFix)
vim.keymap.set('x', '<leader>qf', quickFix)


-- LSP commands
vim.api.nvim_create_user_command('RemoveUnusedImports', ":VtsExec remove_unused_imports", {})
vim.api.nvim_create_user_command('RemoveUnusedCode', ":VtsExec remove_unused", {})
vim.api.nvim_create_user_command('AddMissingImports', ":VtsExec add_missing_imports", {})
vim.api.nvim_create_user_command('FixAll', ":VtsExec fix_all", {})


-- TODO: UI SETTINGS, MOVE TO OWN FILE
local function get_prompt_text(prompt, default_prompt)
  local prompt_text = prompt or default_prompt
  if prompt_text:sub(-1) == ":" then
    prompt_text = "[" .. prompt_text:sub(1, -2) .. "]"
  end
  return prompt_text
end

local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event


local function override_ui_select()
  local UISelect = Menu:extend("UISelect")

  function UISelect:init(items, opts, on_done)
    local border_top_text = get_prompt_text(opts.prompt, "[Select Item]")
    local kind = opts.kind or "unknown"
    local format_item = opts.format_item or function(item)
      return tostring(item.__raw_item or item)
    end

    local popup_options = {
      relative = "editor",
      position = "50%",
      border = {
        style = "rounded",
        text = {
          top = border_top_text,
          top_align = "left",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
      },
      zindex = 999,
    }

    if kind == "codeaction" then
      -- change position for codeaction selection
      popup_options.relative = "cursor"
      popup_options.position = {
        row = 1,
        col = 0,
      }
    end

    local max_width = popup_options.relative == "editor" and vim.o.columns - 4 or vim.api.nvim_win_get_width(0) - 4
    local max_height = popup_options.relative == "editor" and math.floor(vim.o.lines * 80 / 100)
        or vim.api.nvim_win_get_height(0)

    local menu_items = {}
    for index, item in ipairs(items) do
      if type(item) ~= "table" then
        item = { __raw_item = item }
      end
      item.index = index
      local item_text = tostring(index) .. ": " .. string.sub(format_item(item), 0, max_width)
      menu_items[index] = Menu.item(item_text, item)
    end

    local menu_options = {
      min_width = vim.api.nvim_strwidth(border_top_text),
      max_width = max_width,
      max_height = max_height,
      lines = menu_items,
      keymap = {
        focus_next = { "j", "<Down>", "<C-N>" },
        focus_prev = { "k", "<Up>", "<C-P>" },
        close = { "<Esc>", "<C-c>" },
        submit = { "<CR>", "<Space>" },
      },
      on_close = function()
        on_done(nil, nil)
      end,
      on_submit = function(item)
        on_done(item.__raw_item or item, item.index)
      end,
    }

    UISelect.super.init(self, popup_options, menu_options)

    -- cancel operation if cursor leaves select
    self:on(event.BufLeave, function()
      on_done(nil, nil)
    end, { once = true })

    for index, item in ipairs(items) do
      self:map('n', tostring(item.index), function()
        on_done(item.__raw_item or item, item.index)
      end)
    end
  end

  local select_ui = nil

  vim.ui.select = function(items, opts, on_choice)
    assert(type(on_choice) == "function", "missing on_choice function")

    if select_ui then
      -- ensure single ui.select operation
      vim.api.nvim_err_writeln("busy: another select is pending!")
      return
    end

    select_ui = UISelect(items, opts, function(item, index)
      if select_ui then
        -- if it's still mounted, unmount it
        select_ui:unmount()
      end
      -- pass the select value
      on_choice(item, index)
      -- indicate the operation is done
      select_ui = nil
    end)

    select_ui:mount()
  end
end

override_ui_select()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
