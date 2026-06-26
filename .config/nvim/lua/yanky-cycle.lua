-- Transient "keyring" paste cycle on top of yanky.nvim.
--
-- After a paste, <C-p>/<C-n> step to the previous/next entry in the yank
-- history, replacing the just-pasted text in place. The submode is torn down
-- the moment the user moves the cursor, changes mode, leaves the window, or
-- after a timeout. While inactive this module defines no <C-p>/<C-n> mapping,
-- so they fall through to whatever is bound elsewhere.
--
-- The cancel mechanism mirrors yanky's own (yanky.lua attach_cancel): the
-- autocmds that end the submode are cleared right before a cycle and re-created
-- on the next tick, so the cursor movement caused by the cycle's own text
-- replacement happens before the autocmds exist and never ends the submode --
-- only a subsequent, genuine user action does.

local M = {}

local augroup = vim.api.nvim_create_augroup('YankyCycleSubmode', { clear = true })
local cancel_events = { 'CursorMoved', 'ModeChanged', 'CmdlineEnter', 'BufLeave', 'WinLeave' }

local timeout_ms = 2000
local active = false
local buf = nil
local timer = nil

local function restart_timer()
  if not timer then
    timer = vim.uv.new_timer()
  end
  timer:stop()
  timer:start(timeout_ms, 0, vim.schedule_wrap(function()
    M.disarm()
  end))
end

local function attach_cancel()
  vim.api.nvim_clear_autocmds({ group = augroup })
  vim.schedule(function()
    if not active then
      return
    end
    vim.api.nvim_create_autocmd(cancel_events, {
      group = augroup,
      buffer = buf,
      callback = function()
        M.disarm()
      end,
    })
  end)
end

function M.disarm()
  if not active then
    return
  end
  active = false
  if timer then
    timer:stop()
  end
  vim.api.nvim_clear_autocmds({ group = augroup })
  if buf and vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.keymap.del, 'n', '<C-p>', { buffer = buf })
    pcall(vim.keymap.del, 'n', '<C-n>', { buffer = buf })
  end
  buf = nil
end

function M.cycle(dir)
  local yanky = require('yanky')
  if not yanky.can_cycle() then
    return M.disarm()
  end
  vim.api.nvim_clear_autocmds({ group = augroup }) -- don't let our own edit cancel us
  yanky.cycle(dir) -- 1 = previous/older entry, -1 = next/newer entry
  restart_timer()
  attach_cancel()
end

function M.arm()
  if not require('yanky').can_cycle() then
    return
  end
  restart_timer()
  if active then
    return
  end
  active = true
  buf = vim.api.nvim_get_current_buf()
  vim.keymap.set('n', '<C-p>', function()
    M.cycle(1)
  end, { buffer = buf, desc = 'Yanky cycle to previous entry' })
  vim.keymap.set('n', '<C-n>', function()
    M.cycle(-1)
  end, { buffer = buf, desc = 'Yanky cycle to next entry' })
  attach_cancel()
end

function M.put(type)
  local mode = vim.api.nvim_get_mode().mode
  local is_visual = mode:match('^[vV\22]') ~= nil
  require('yanky').put(type, is_visual)
  M.arm()
end

function M.setup(opts)
  if opts and opts.timeout_ms then
    timeout_ms = opts.timeout_ms
  end
end

return M
