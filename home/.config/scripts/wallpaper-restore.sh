#!/usr/bin/env bash

WALLPAPER_FILE="$HOME/.config/last-wallpaper"

# Ждём, пока awww-daemon действительно станет доступен
for i in {1..20}; do
    if awww query >/dev/null 2>&1; then
        break
    fi
    sleep 0.25
done

if [ -f "$WALLPAPER_FILE" ]; then
    wallpaper="$(cat "$WALLPAPER_FILE")"

    if [ -f "$wallpaper" ]; then
        awww img "$wallpaper" --transition-type none
    fi
fi
