require('telescope').setup {
  defaults = {
    path_display = { "truncate" },
    layout_config = {
      horizontal = { prompt_position = 'top' }
    },
    sorting_strategy = "ascending"
  },
}

local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { desc = desc })
end

require('telescope').load_extension('luasnip')

require 'telescope-all-recent'.setup {}

local function setKeymaps()
  vim.api.nvim_set_keymap('n', '<C-P>', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>p', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>rf', "<cmd>lua require('telescope.builtin').oldfiles({only_cwd = true})<CR>",
    { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>fa', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>fs', "<cmd>lua require('telescope.builtin').grep_string()<CR>",
    { noremap = true })
  vim.api.nvim_set_keymap('x', '<leader>fs', "<cmd>lua require('telescope.builtin').grep_string()<CR>",
    { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>fc', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>",
    { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>bf', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>gs', "<cmd>lua require('telescope.builtin').git_status()<CR>", { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>gl', "<cmd>lua require('telescope.builtin').git_commits()<CR>",
    { noremap = true })
  vim.keymap.set('n', '<leader>d', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,
    { noremap = true })

  -- lsp finders
  --
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
  nmap('<leader>o', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
  nmap('<C-T>', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
end

vim.api.nvim_set_keymap('n', '<leader>fz',
  "<cmd>lua require('telescope.builtin').grep_string({ shorten_path = true, word_match = '-w', only_sort_text = true, search = '' })<CR>",
  { noremap = true })

-- setKeymaps()
