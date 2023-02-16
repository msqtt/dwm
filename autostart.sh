#!/bin/bash

# xrandr --output HDMI-A-0 --mode 2560x1440 --rate 74.97 --right-of eDP

/home/msqt/Project/Software/dwm-6.4/sh/dwm_status.sh &

dunst &

electron-qq --hide &

wm.sh

ttp.sh &

fcitx5 -d

# st -e signin.sh &
