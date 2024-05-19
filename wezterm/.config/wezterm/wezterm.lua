-- Pull in the wezterm API

local wezterm = require("wezterm")

-- This will hold the configuration.

local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- config.font = wezterm.font 'JetBrains Mono'
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })

-- For example, changing the color scheme:

-- config.color_scheme = "catppuccin-macchiato"
config.color_scheme = "OneDark (base16)"

-- Key bindings
config.disable_default_key_bindings = true

local act = wezterm.action

config.keys = {
	{ mods = "CTRL", key = "c", action = act.CopyTo("Clipboard") },
	{ mods = "CTRL", key = "v", action = act.PasteFrom("Clipboard") },
	{ mods = "CTRL", key = "=", action = act.IncreaseFontSize },
	{ mods = "CTRL", key = "-", action = act.DecreaseFontSize },
	{ mods = "CTRL", key = "0", action = act.ResetFontSize },
	--  {mods="CTRL", key="p", action=act.ActivateCommandPalette},
	{ mods = "CTRL", key = "f", action = act.Search({ CaseSensitiveString = "" }) },
}

-- and finally, return the configuration to wezterm

return config
