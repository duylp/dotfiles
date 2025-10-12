#!/bin/sh

picom -b &
  xinput set-prop "ETPS/2 Elantech Touchpad" "libinput Tapping Enabled" 1 &
  flameshot &
  nm-applet &
  ibus-daemon -dr &
  autorandr --change &
