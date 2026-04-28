vim.api.nvim_create_user_command('CodeActions', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local cursor_lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local raw_diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor_lnum })
  local diagnostics = vim.tbl_map(function(d)
    return d.user_data and d.user_data.lsp or {}
  end, raw_diagnostics)

  local actions = {}

  for _, client in ipairs(clients) do
    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
    params.context = {
      diagnostics = diagnostics,
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    }

    local result =
      client:request_sync('textDocument/codeAction', params, 3000, bufnr)
    if result and result.result then
      for _, action in ipairs(result.result) do
        table.insert(actions, { action = action, client = client })
      end
    end
  end

  if vim.tbl_isempty(actions) then
    vim.notify('No code actions available', vim.log.levels.INFO)
    return
  end

  local titles = vim.tbl_map(function(item)
    return string.format('[%s] %s', item.client.name, item.action.title)
  end, actions)

  vim.schedule(function()
    vim.ui.select(
      titles,
      { prompt = 'Code Actions', kind = 'codeaction' },
      function(_, idx)
        if not idx then
          return
        end

        local selected = actions[idx]
        local action = selected.action
        local client = selected.client

        if
          not action.edit
          and action.command == nil
          and client.supports_method 'codeAction/resolve'
        then
          local resolved =
            client:request_sync('codeAction/resolve', action, 3000, bufnr)
          if resolved and resolved.result then
            action = resolved.result
          end
        end

        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
        end

        if action.command then
          local command = type(action.command) == 'table' and action.command
            or action
          client:request_sync('workspace/executeCommand', command, 3000, bufnr)
        end
      end
    )
  end)
end, {})
