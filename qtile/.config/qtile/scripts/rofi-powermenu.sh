#!/usr/bin/env bash

# Rofi power menu: horizontal row of options using rofi's default/configured theme.

shutdown=$' Shutdown'
reboot=$' Reboot'
# suspend=$' Suspend'
# lock=$' Lock'
logout=$' Logout'

options="$shutdown
$reboot
$logout"
# $suspend
# $lock

chosen=$(echo "$options" | rofi -dmenu -i -p "Power")

case "$chosen" in
    "$shutdown") systemctl poweroff ;;
    "$reboot")   systemctl reboot ;;
    # "$suspend")  systemctl suspend ;;
    # "$lock")     loginctl lock-session ;;
    "$logout")   qtile cmd-obj -o cmd -f shutdown ;;
esac
