-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

-- This is where you actually apply your config choices

config.colors = {
  -- The default text color
  foreground = 'white',
  cursor_bg = 'white'
}


config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.send_composed_key_when_left_alt_is_pressed = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}


config.leader = { key = 'Space', mods = 'CTRL|SHIFT' }

config.keys = {
  {
    key = 'Space',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'Enter',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },
  {
    key = 'F',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.Search({ CaseInSensitiveString = '' })
  },
  {
    key = 'G',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.EmitEvent 'trigger-vim-with-scrollback',
  },
  {
    key = '{',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = '}',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  { key = 'UpArrow',   mods = 'SHIFT', action = act.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },
  {
    key = 'a',
    mods = 'LEADER',
    action = act.PaneSelect {},
  },
}

config.key_tables = {
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments above.
  resize_pane = {
    { key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'h',          action = act.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'l',          action = act.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'k',          action = act.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'j',          action = act.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape',     action = 'PopKeyTable' },
  },

  -- Defines the keys that are active in our activate-pane mode.
  -- 'activate_pane' here corresponds to the name="activate_pane" in
  -- the key assignments above.
  activate_pane = {
    { key = 'LeftArrow',  action = act.ActivatePaneDirection 'Left' },
    { key = 'h',          action = act.ActivatePaneDirection 'Left' },

    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'l',          action = act.ActivatePaneDirection 'Right' },

    { key = 'UpArrow',    action = act.ActivatePaneDirection 'Up' },
    { key = 'k',          action = act.ActivatePaneDirection 'Up' },

    { key = 'DownArrow',  action = act.ActivatePaneDirection 'Down' },
    { key = 'j',          action = act.ActivatePaneDirection 'Down' },
  },
}

config.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}

config.use_fancy_tab_bar = false


local io = require 'io'
local os = require 'os'
local act = wezterm.action

local function my_fixed_get_text_from_semantic_zone(pane, zone)
  -- Unfortunately, the function `get_text_from_semantic_zone(zone)` swallows the last line.
  -- So we need to get the region up to column 0 of the line that follows the zone.
  return pane:get_text_from_region(zone.start_x, zone.start_y, 0, zone.end_y + 1)
end

wezterm.on('trigger-vim-with-scrollback', function(window, pane)
  -- Retrieve the text from the pane
  local zones = pane:get_semantic_zones("Output")
  local zone = zones[#zones]
  local text = my_fixed_get_text_from_semantic_zone(pane, zone)

  print(text)

  -- Create a temporary file to pass to vim
  local name = os.tmpname()
  local f = io.open(name, 'w+')
  f:write(text)
  f:flush()
  f:close()

  window:perform_action(
    act.SpawnCommandInNewTab {
      args = { 'nvim', '-u', 'NONE', '-c', 'map <silent> q :qa!<CR>', '-c', 'set termguicolors ignorecase smartcase clipboard+=unnamedplus', name },
    },
    pane
  )

  -- Wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  --
  -- Note: We don't strictly need to remove this file, but it is nice
  -- to avoid cluttering up the temporary directory.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

local function detect_host_os()
  -- package.config:sub(1,1) returns '\' for windows and '/' for *nix.
  if package.config:sub(1, 1) == '\\' then
    return 'windows'
  else
    -- uname should be available on *nix systems.
    local check = io.popen('uname -s')
    local result = check:read('*l'); check:close()

    if result == 'Darwin' then
      return 'macos'
    else
      return 'linux'
    end
  end
end

local host_os = detect_host_os()

if host_os == 'macos' then
  -- check homebrew binary symlinks on startup.
  config.set_environment_variables = {
    PATH = '/Users/efraintlapale/neovim/bin:' .. os.getenv('PATH')
  }

  config.window_decorations = "RESIZE"
  config.font_size = 14
  config.window_padding.top = 10
end



wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local process = pane.foreground_process_name
  -- Get the current working directory of the pane
  local cwd = pane.current_working_dir.file_path


  -- Set the window title based on the cwd
  if cwd then
    local dir_name = cwd:match("([^/]+)/*$")
    local procName = process:match("([^/]+)/*$")
    return procName .. ": " .. dir_name
  else
    return 'WezTerm' -- Default title if no cwd available
  end
end)

-- and finally, return the configuration to wezterm
return config
