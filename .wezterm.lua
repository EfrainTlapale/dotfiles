-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.colors = {
  -- The default text color
  foreground = 'white',
  cursor_bg = 'white'
}


config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.keys = {
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


-- and finally, return the configuration to wezterm
return config
