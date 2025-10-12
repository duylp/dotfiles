#!/usr/bin/env bash

# Rofi script to list and apply autorandr display profiles

# Check if autorandr is installed
if ! command -v autorandr &> /dev/null; then
    rofi -e "Error: autorandr is not installed or not in PATH"
    exit 1
fi

# Get list of available autorandr profiles
profiles=$(autorandr --list 2>/dev/null)

# Sort profiles alphabetically
profiles=$(echo "$profiles" | sort)

# Check if there are any profiles
if [ -z "$profiles" ]; then
    rofi -e "No autorandr profiles found"
    exit 1
fi

# Get the currently active profile
current=$(autorandr --current 2>/dev/null)

# Get the detected profiles (can be multiple lines)
detected=$(autorandr --detected 2>/dev/null)

# Build the menu with labels
menu=""
while IFS= read -r profile; do
    line="$profile"
    # Check if profile is in the detected list
    if echo "$detected" | grep -qx "$profile"; then
        line="$line (detected)"
    fi
    if [ "$profile" = "$current" ]; then
        line="$line (current)"
    fi
    menu="$menu$line"$'\n'
done <<< "$profiles"

# Show profiles in rofi and get user selection
selected=$(echo -n "$menu" | rofi -dmenu -i -p "Display Profile")

# If user selected a profile, apply it
if [ -n "$selected" ]; then
    # Extract the profile name (remove labels)
    profile_name=$(echo "$selected" | sed 's/ (current)//g' | sed 's/ (detected)//g' | xargs)
    
    autorandr --load "$profile_name"
    if [ $? -eq 0 ]; then
        notify-send "Display Profile" "Applied profile: $profile_name" -t 2000
    else
        notify-send "Display Profile" "Failed to apply profile: $profile_name" -u critical
    fi
fi
