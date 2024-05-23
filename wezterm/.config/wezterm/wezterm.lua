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
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 3000 }

local act = wezterm.action

config.keys = {
	{ mods = "CTRL", key = "c", action = act.CopyTo("Clipboard") },
	{ mods = "CTRL", key = "v", action = act.PasteFrom("Clipboard") },
	{ mods = "CTRL", key = "=", action = act.IncreaseFontSize },
	{ mods = "CTRL", key = "-", action = act.DecreaseFontSize },
	{ mods = "CTRL", key = "0", action = act.ResetFontSize },
	{ mods = "LEADER", key = "p", action = act.ActivateCommandPalette },
	{ mods = "CTRL", key = "f", action = act.Search({ CaseSensitiveString = "" }) },
	-- multiplexing keymap
	{ key = "%", mods = "LEADER|SHIFT", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = '"', mods = "LEADER|SHIFT", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "h", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
}

-- and finally, return the configuration to wezterm

return config
