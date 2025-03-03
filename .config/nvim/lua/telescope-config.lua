require('telescope').setup {
  defaults = {
    path_display = { "truncate" },
  },
}

-- require('telescope').load_extension('luasnip')

require 'telescope-all-recent'.setup {}

-- vim.api.nvim_set_keymap('n', '<C-P>', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>p', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>rf', "<cmd>lua require('telescope.builtin').oldfiles({only_cwd = true})<CR>",
-- { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>fa', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>fs', "<cmd>lua require('telescope.builtin').grep_string()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap('x', '<leader>fs', "<cmd>lua require('telescope.builtin').grep_string()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>fc', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>",
-- { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>bf', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>gs', "<cmd>lua require('telescope.builtin').git_status()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>gl', "<cmd>lua require('telescope.builtin').git_commits()<CR>", { noremap = true })
-- vim.keymap.set('n', '<leader>d', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,
-- { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fz',
  "<cmd>lua require('telescope.builtin').grep_string({ shorten_path = true, word_match = '-w', only_sort_text = true, search = '' })<CR>",
  { noremap = true })
