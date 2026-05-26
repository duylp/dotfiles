-- Pull in the wezterm API

local wezterm = require("wezterm")

-- This will hold the configuration.

local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- config.font = wezterm.font("JetBrains Mono")
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })

-- For example, changing the color scheme:

-- config.color_scheme = "catppuccin-macchiato"
config.color_scheme = "OneDark (base16)"

-- Key bindings
config.disable_default_key_bindings = true
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1500 }

local act = wezterm.action

-- Navigator.nvim integration: detect if Neovim is running in the active pane
local function is_vim(pane)
	local process_info = pane:get_foreground_process_info()
	if process_info then
		local process_name = process_info.name
		return process_name == "nvim" or process_name == "vim"
	end
	return false
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function nav(key)
	return {
		key = key,
		mods = "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- Pass the key through to Neovim
				win:perform_action({ SendKey = { key = key, mods = "CTRL" } }, pane)
			else
				win:perform_action(act.ActivatePaneDirection(direction_keys[key]), pane)
			end
		end),
	}
end

-- Read VIRTUAL_ENV exposed by the shell via OSC 1337 SetUserVar (see zshrc).
local function get_venv(pane)
	local user_vars = pane:get_user_vars()
	local v = user_vars and user_vars.VIRTUAL_ENV
	if v == nil or v == "" then
		return nil
	end
	return v
end

local function split_with_venv(direction)
	return wezterm.action_callback(function(_, pane)
		local venv = get_venv(pane)
		local new_pane = pane:split({ direction = direction, domain = "CurrentPaneDomain" })
		if venv then
			new_pane:send_text("source " .. venv .. "/bin/activate\n")
		end
	end)
end

config.keys = {
	-- Navigator.nvim: seamless Ctrl+hjkl navigation between Neovim and WezTerm panes
	nav("h"),
	nav("j"),
	nav("k"),
	nav("l"),
	{ mods = "CTRL", key = "c", action = act.CopyTo("Clipboard") },
	{ mods = "CTRL", key = "v", action = act.PasteFrom("Clipboard") },
	-- { mods = "CTRL", key = "=", action = act.IncreaseFontSize },
	-- { mods = "CTRL", key = "-", action = act.DecreaseFontSize },
	-- { mods = "CTRL", key = "0", action = act.ResetFontSize },
	{ mods = "LEADER", key = "p", action = act.ActivateCommandPalette },
	{ mods = "CTRL", key = "f", action = act.Search({ CaseSensitiveString = "" }) },
	-- multiplexing keymap
	{ key = "%", mods = "LEADER|SHIFT", action = split_with_venv("Right") },
	{ key = '"', mods = "LEADER|SHIFT", action = split_with_venv("Bottom") },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "h", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	-- Launch claude in a new right-side pane, activating the parent's venv first.
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action_callback(function(_, pane)
			local venv = get_venv(pane)
			local right = pane:split({ direction = "Right", size = 0.4, domain = "CurrentPaneDomain" })
			if venv then
				right:send_text("source " .. venv .. "/bin/activate\n")
			end
			right:send_text("claude\n")
		end),
	},
	-- Workspace management
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "W",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new workspace name:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
}

-- Leader key indicator in status bar
wezterm.on("update-right-status", function(window, _)
	local leader = ""
	if window:leader_is_active() then
		leader = wezterm.format({
			{ Foreground = { Color = "#282c34" } },
			{ Background = { Color = "#98c379" } },
			{ Text = " LEADER " },
		})
	end
	window:set_left_status(leader)

	local workspace = wezterm.format({
		{ Foreground = { Color = "#282c34" } },
		{ Background = { Color = "#61afef" } },
		{ Text = " " .. window:active_workspace() .. " " },
	})
	window:set_right_status(workspace)
end)

config.use_fancy_tab_bar = false

config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 0.8,
}

config.colors = {
	split = "#61afef",
}

-- and finally, return the configuration to wezterm

return config
