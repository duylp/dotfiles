#!/usr/bin/env bash

# Rofi script to search and copy passwords from pass (the standard unix password manager)

PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

# Check if pass is installed
if ! command -v pass &> /dev/null; then
    rofi -e "Error: pass is not installed or not in PATH"
    exit 1
fi

# Check if the password store exists
if [ ! -d "$PASSWORD_STORE_DIR" ]; then
    rofi -e "Error: Password store not found at $PASSWORD_STORE_DIR"
    exit 1
fi

# List all entries (strip the store path prefix and .gpg suffix)
entries=$(find "$PASSWORD_STORE_DIR" -name '*.gpg' -printf '%P\n' | sed 's/\.gpg$//' | sort)

if [ -z "$entries" ]; then
    rofi -e "No entries found in password store"
    exit 1
fi

# Show entries in rofi
selected=$(echo "$entries" | rofi -dmenu -i -p "Pass")

# If user selected an entry, copy the password to clipboard
if [ -n "$selected" ]; then
    pass show -c -- "$selected"
    if [ $? -eq 0 ]; then
        notify-send "Pass" "Copied password for: $selected" -t 3000
    else
        notify-send "Pass" "Failed to copy password for: $selected" -u critical
    fi
fi
