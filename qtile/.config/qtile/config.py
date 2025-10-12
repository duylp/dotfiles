# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.scripts.main import VERSION
from libqtile.utils import guess_terminal
from libqtile import extension

from catppuccin import PALETTE
from widgets import CustomBattery, CustomPulseVolume

# palette = PALETTE.latte.colors
# palette = PALETTE.frappe.colors
palette = PALETTE.macchiato.colors
# palette = PALETTE.mocha.colors


mod = "mod4"
# terminal = guess_terminal()
terminal = "/home/duy/bin/wezterm"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "i", lazy.layout.grow()),
    Key([mod, "control"], "m", lazy.layout.shrink()),
    Key([mod, "control"], "n", lazy.layout.reset()),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # rofi
    Key(
        [mod],
        "e",
        lazy.spawn("rofi -i -show drun -modi drun -show-icons"),
        desc="Rofi app launcher",
    ),
    Key(
        [mod],
        "p",
        lazy.spawn(os.path.expanduser("~/.config/qtile/scripts/rofi-autorandr.sh")),
        desc="Rofi autorandr profile selector",
    ),
    # kill binding
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    # Volume
    # Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle")),
    # Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 5%+")),
    # Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    ),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    # layout.Columns(
    #     border_focus=palette.green.hex,
    #     border_focus_stack=palette.lavender.hex,
    #     border_normal=palette.surface2.hex,
    #     border_normal_stack=palette.surface1.hex,
    #     border_width=4,
    #     border_on_single=False,
    #     margin=5,
    # ),
    # layout.Plasma(
    #     border_focus=palette.sky.hex,
    #     border_width=4,
    # ),
    layout.MonadTall(
        border_focus=palette.green.hex,
        border_normal=palette.surface2.hex,
        border_width=4,
        single_border_width=0,
        margin=8,
        ratio=0.6,
    ),
    layout.Max(
        border_focus=palette.peach.hex,
        border_normal=palette.surface2.hex,
        border_width=0,
        margin=0,
    ),
    # layout.Floating(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    # font="sans",
    font="JetBrainsMono NF SemiBold",
    fontsize=12,
    padding=5,
    foreground=palette.crust.hex,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(
                    foreground=palette.peach.hex,
                    background=palette.surface1.hex,
                ),
                widget.GroupBox(
                    highlight_method="block",
                    this_current_screen_border=palette.sky.hex,
                    this_screen_border=palette.surface2.hex,
                    active=palette.peach.hex,
                    inactive=palette.overlay0.hex,
                    highlight_color=[palette.sky.hex, palette.sky.hex],
                    block_highlight_text_color=palette.crust.hex,
                    urgent_border=palette.red.hex,
                    rounded=True,
                    borderwidth=2,
                    padding=3,
                ),
                widget.Prompt(
                    prompt="Run: ",
                    foreground=palette.text.hex,
                    cursor_color=palette.sky.hex,
                    background=palette.surface0.hex,
                ),
                widget.TaskList(
                    border=palette.sky.hex,
                    unfocused_border=palette.surface2.hex,
                    urgent_border=palette.red.hex,
                    borderwidth=2,
                    highlight_method="block",
                    padding_y=2,
                    padding_x=5,
                    max_title_width=200,
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(
                    background=palette.teal.hex,
                    icon_size=20,
                ),
                widget.CPU(
                    format="CPU {load_percent:>4.1f}%",
                    background=palette.peach.hex,
                    update_interval=2.0,
                ),
                widget.Memory(
                    format="Mem {MemUsed:>4.1f}{mm}",
                    measure_mem="G",
                    background=palette.yellow.hex,
                    update_interval=2.0,
                ),
                CustomPulseVolume(
                    mute_icon=" ",
                    low_icon=" ",
                    high_icon=" ",
                    threshold=50,
                    background=palette.sky.hex,
                    limit_max_volume=True,
                    step=5,
                ),
                CustomBattery(
                    low_icon=" ",
                    medium_icon=" ",
                    high_icon=" ",
                    low_threshold=33,
                    high_threshold=67,
                    background=palette.green.hex,
                    update_interval=60,
                ),
                widget.Clock(
                    format="  %a %d/%m",
                    background=palette.lavender.hex,
                ),
                widget.Clock(
                    format="  %I:%M %p",
                    background=palette.text.hex,
                ),
                widget.QuickExit(
                    background=palette.red.hex,
                    default_text=" ",
                    countdown_format="{}",
                ),
            ],
            24,
            background=palette.surface0.hex,
            opacity=0.9,
        ),
        wallpaper="/home/duy/Pictures/Wallpapers/sunset.jpg",
        wallpaper_mode="stretch",
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
# wmname = "LG3D"
wmname = f"Qtile {VERSION}"


def _update_timezone():
    for screen in screens:
        for w in screen.top.widgets:
            if isinstance(w, widget.Clock):
                w.use_system_timezone()


@hook.subscribe.startup
def autostart():
    home = os.path.expanduser("~/.config/qtile/scripts/autostart.sh")
    subprocess.call([home])

    _update_timezone()
