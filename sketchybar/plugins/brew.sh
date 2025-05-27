#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

COUNT=$(brew outdated | wc -l | tr -d ' ')

COLOR=$RED

case "$COUNT" in
  [3-5][0-9]) COLOR=$RED
  ;;
  [1-2][0-9]) COLOR=$RED
  ;;
  [1-9]) COLOR=$RED
  ;;
  0) COLOR=$RED
     COUNT=􀆅
  ;;
esac

sketchybar --set $NAME label=$COUNT icon.color=$RED
