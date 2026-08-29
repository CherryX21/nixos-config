#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

wallpaper=$(
    find "$WALLPAPER_DIR" -type f \
        \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
        -printf '%f\n' |
    sort |
    fuzzel --dmenu --prompt="Wallpaper > "
)

# Ничего не выбрали — просто выходим
[ -z "$wallpaper" ] && exit 0

wallpaper="$WALLPAPER_DIR/$wallpaper"

printf '%s\n' "$wallpaper" > "$HOME/.config/last-wallpaper"

# Ставим обои
awww img "$wallpaper" \
    --transition-type grow \
    --transition-duration 0.7 \
    --transition-fps 60 \
    --transition-pos center

# Генерируем цвета без вопроса
matugen image "$wallpaper" --source-color-index 0

swaync-client --reload-css

# Перезапускаем Waybar
pkill waybar
waybar >/dev/null 2>&1 &
