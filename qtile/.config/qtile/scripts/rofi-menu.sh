#!/usr/bin/env bash

# Rofi meta menu to launch other rofi scripts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -A options=(
    [" App Launcher"]="rofi -i -show drun -modi drun -show-icons"
    [" Display Profiles"]="$SCRIPT_DIR/rofi-autorandr.sh"
    [" Passwords"]="$SCRIPT_DIR/rofi-pass.sh"
)

chosen=$(printf '%s\n' "${!options[@]}" | sort | rofi -dmenu -i -p "Menu")

if [ -n "$chosen" ]; then
    eval "${options[$chosen]}"
fi
