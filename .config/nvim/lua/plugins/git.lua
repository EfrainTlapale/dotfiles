return {
  {
    'f-person/git-blame.nvim',
    opts = { enabled = false },
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'sindrets/diffview.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        preview_config = { border = 'rounded' },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          map({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
          map({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function()
            gs.blame_line({ full = true })
          end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map({ 'o', 'x' }, 'ih', '<cmd><C-U>Gitsigns select_hunk<CR>')
        end,
      })
    end,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = true,
  },
  {
    'vieitesss/minifugit.nvim',
    cmd = { 'MinifugitStatus' },
  },
  {
    'esmuellert/codediff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
  },
}
