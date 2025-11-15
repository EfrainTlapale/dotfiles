-- lua/quickrun.lua

local M = {}

-- 1. Persistent storage for the command string
local last_command = nil
local mapped_key = '<Leader>rr' -- The default keymap you requested

--- 2. Function to prompt for and store the command
-- The function now accepts an 'opts' table from the nvim_create_user_command handler
function M.set_command(opts)
  local cmd_str = nil

  -- Check if an argument was provided (e.g., :SetQuickRunCommand LazyGit)
  if opts and opts.args and #opts.args > 0 then
    -- Use the argument directly
    cmd_str = opts.args
  else
    -- If no argument, prompt the user as before
    -- Use vim.fn.input() to get the command from the user
    cmd_str = vim.fn.input('Set Quick Command: ', last_command or '')
  end

  -- Check if the user entered a command (or confirmed an existing one)
  if cmd_str and #cmd_str > 0 then
    -- Trim leading/trailing whitespace just in case
    last_command = cmd_str:gsub("^%s*(.-)%s*$", "%1")
    vim.notify('Quick Command set to: ' .. last_command, vim.log.levels.INFO)
  else
    vim.notify('Quick Command not set. Input was empty.', vim.log.levels.WARN)
  end
end

--- 3. Function that runs the stored command or displays a warning
function M.run_command()
  if last_command then
    -- Use vim.cmd to execute the stored command
    -- We prepend the ':' to ensure it's executed as an Ex command
    vim.cmd(':' .. last_command)
  else
    -- Show a warning if no command has been set
    vim.notify(
      'No Quick Command defined! Run :SetQuickRunCommand first.',
      vim.log.levels.WARN,
      { title = "QuickRun Warning" }
    )
  end
end

-- 4. Create the User Commands and Keymap
function M.setup()
  -- Define the User Command to set the command
  -- Added the 'nargs' property to allow the command to accept arguments (0 or 1)
  -- '?' means 0 or 1 argument
  vim.api.nvim_create_user_command(
    'SetQuickRunCommand',
    M.set_command,
    {
      desc = 'Sets the command to be run by the quick-run keymap',
      nargs = '?',         -- This allows 0 or 1 argument
      complete = 'command' -- Optional: Enables command completion for the argument
    }
  )

  -- Define the Keymap using a Lua function for the highest performance and control
  -- <Leader>rr (or whichever key you prefer) will call M.run_command()
  vim.keymap.set('n', mapped_key, M.run_command, {
    noremap = true,
    silent = true,
    desc = 'Run the defined quick command'
  })
end

return M
