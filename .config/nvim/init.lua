local dotenv = require 'lua-dotenv'
-- Check if file exists before loading to prevent errors
local env_path = vim.fs.normalize '~/.config/nvim/.env.local'
if vim.fn.filereadable(env_path) == 1 then
  dotenv.load_dotenv(env_path)
end

require 'basics'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = { { import = 'plugins' } },
  install = { colorscheme = { 'habamax' } },
})

-- Set the active colorscheme (gruvbox-material via lua/colors.lua)
require 'colors'

-- User modules that aren't plugin-tied
require('quickrun').setup()
require 'code-actions'
require 'ui-select'

vim.api.nvim_create_user_command(
  'DismissNotifications',
  ":lua require('notify').dismiss()",
  {}
)

-- Custom Notify wrapper
vim.notify = function(msg, level, opts)
  if
    msg
    and string.find(msg, 'multiple different client offset_encodings detected')
  then
    return
  end
  return require('notify').notify(msg, level, opts)
end
