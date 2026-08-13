-- Pull in the wezterm API
local wezterm = require("wezterm")
local io = require("io")
local os = require("os")

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

-- This is where you actually apply your config choices

config.colors = {
	-- The default text color
	foreground = "white",
	cursor_bg = "white",
	background = "#0d1117",
	ansi = {
		"#1e1e1e", -- black
		"#cc6666", -- red
		"#98c379", -- green
		"#e5c07b", -- yellow
		"#61afef", -- blue
		"#c678dd", -- magenta
		"#56b6c2", -- cyan
		"#abb2bf", -- white
	},
	brights = {
		"#5c6370", -- bright black
		"#e06c75", -- bright red
		"#98c379", -- bright green
		"#e5c07b", -- bright yellow
		"#61afef", -- bright blue
		"#c678dd", -- bright magenta
		"#56b6c2", -- bright cyan
		"#ffffff", -- bright white
	},
}

config.font = wezterm.font("FiraCode Nerd Font")
-- config.font = wezterm.font("AtkynsonMono NF")

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.send_composed_key_when_left_alt_is_pressed = true
config.window_close_confirmation = "NeverPrompt"
config.warn_about_missing_glyphs = false

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.leader = { key = "Space", mods = "CTRL|SHIFT" }

config.keys = {
	{
		key = "Space",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "Enter",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "F",
		mods = "CTRL|SHIFT",
		action = wezterm.action.Search({ CaseInSensitiveString = "" }),
	},
	{
		key = "G",
		mods = "CTRL|SHIFT",
		action = wezterm.action.EmitEvent("trigger-vim-with-scrollback"),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = wezterm.action.EmitEvent("trigger-vim-with-viewport"),
	},
	{
		key = "{",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "}",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	{
		key = "a",
		mods = "LEADER",
		action = act.PaneSelect({}),
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
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },

		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },

		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },

		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	},
}

config.mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
}

config.use_fancy_tab_bar = false

local function my_fixed_get_text_from_semantic_zone(pane, zone)
	-- Unfortunately, the function `get_text_from_semantic_zone(zone)` swallows the last line.
	-- So we need to get the region up to column 0 of the line that follows the zone.
	return pane:get_text_from_region(zone.start_x, zone.start_y, 0, zone.end_y + 1)
end

local function open_text_in_vim(window, pane, text)
	if not text or text == "" then
		wezterm.log_warn("nothing to open in vim")
		return
	end

	-- Create a temporary file to pass to vim
	local name = os.tmpname()
	local f = io.open(name, "w+")
	if not f then
		wezterm.log_error("could not open temp file " .. name)
		return
	end
	f:write(text)
	f:flush()
	f:close()

	window:perform_action(
		act.SpawnCommandInNewTab({
			args = {
				"nvim",
				"-u",
				"NONE",
				"-c",
				"map <silent> q :qa!<CR>",
				"-c",
				"set termguicolors ignorecase smartcase clipboard+=unnamedplus",
				name,
			},
		}),
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
end

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
	-- Retrieve the text of the last command's output from the pane.
	-- There are no zones at all until the shell integration in wezterm.sh has
	-- emitted its first OSC 133 marker, so bail out instead of indexing nil.
	local zones = pane:get_semantic_zones("Output")
	local zone = zones[#zones]
	if not zone then
		wezterm.log_warn("no semantic zones in this pane; is shell integration loaded?")
		return
	end

	open_text_in_vim(window, pane, my_fixed_get_text_from_semantic_zone(pane, zone))
end)

wezterm.on("trigger-vim-with-viewport", function(window, pane)
	-- get_lines_as_text() with no argument returns only the visible viewport,
	-- not the full scrollback.
	local text = pane:get_lines_as_text()

	open_text_in_vim(window, pane, text)
end)

local function detect_host_os()
	-- package.config:sub(1,1) returns '\' for windows and '/' for *nix.
	if package.config:sub(1, 1) == "\\" then
		return "windows"
	else
		-- uname should be available on *nix systems.
		local check = io.popen("uname -s")
		local result = check:read("*l")
		check:close()

		if result == "Darwin" then
			return "macos"
		else
			return "linux"
		end
	end
end

local host_os = detect_host_os()
local bob_nvim_bin = wezterm.home_dir .. "/.local/share/bob/nvim-bin"

if host_os == "macos" then
	-- check homebrew binary symlinks on startup.
	config.set_environment_variables = {
		PATH = bob_nvim_bin .. ":/opt/homebrew/bin:" .. os.getenv("PATH"),
	}

	config.window_decorations = "RESIZE"
	config.font_size = 15.8
	config.window_padding.top = 10
else
	-- Detect if an external monitor is connected by reading /sys/class/drm,
	-- the kernel's view of connected displays. Works under X11 and Wayland.
	-- Any connected output whose name isn't an internal panel (eDP/LVDS) counts as external.
	-- Only re-evaluated when the config is reloaded, not on hotplug.
	local function has_external_monitor()
		local check = io.popen(
			"for d in /sys/class/drm/card*-*/status; do "
				.. '[ "$(cat "$d" 2>/dev/null)" = connected ] && basename "$(dirname "$d")"; '
				.. "done 2>/dev/null"
		)
		if not check then
			return false
		end
		local found = false
		for line in check:lines() do
			-- Names look like "card0-eDP-1", "card0-DP-2", "card0-HDMI-A-1".
			local output = line:match("^card%d+%-(.+)$") or line
			if not output:match("^eDP") and not output:match("^LVDS") then
				found = true
				break
			end
		end
		check:close()
		return found
	end

	if has_external_monitor() then
		config.font_size = 9
	else
		config.font_size = 11
	end

	config.set_environment_variables = {
		-- prepend the path to your utility and include the rest of the PATH
		PATH = bob_nvim_bin .. ":" .. os.getenv("PATH"),
	}
end

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	-- Both of these are absent in panes that never reported them (a fresh pane,
	-- or a shell without OSC 7 / OSC 133 integration), so read them defensively
	-- rather than indexing straight through.
	local cwd_uri = pane.current_working_dir
	local cwd = cwd_uri and cwd_uri.file_path
	local dir_name = cwd and cwd:match("([^/]+)/*$")

	if not dir_name then
		return "WezTerm"
	end

	local process = pane.foreground_process_name
	local proc_name = process and process:match("([^/]+)/*$")

	if proc_name then
		return proc_name .. ": " .. dir_name
	end
	return dir_name
end)

-- and finally, return the configuration to wezterm
return config
