#!/usr/bin/env bash

# Смотрим, есть ли уже хоть какие-то сети в кэше
cached=$(
    nmcli -t -f SSID device wifi list |
    sed '/^$/d'
)

# Если кэш пустой — показываем "загрузку"
if [ -z "$cached" ]; then
    (
        printf 'Scanning Wi-Fi…\n' |
        fuzzel \
            --dmenu \
            --prompt="" \
            --lines=1 \
            --width=24
    ) &
    loading_pid=$!

    nmcli device wifi rescan >/dev/null 2>&1
    sleep 0.3

    kill "$loading_pid" 2>/dev/null
else
    # Если кэш уже есть — обновляем его в фоне
    nmcli device wifi rescan >/dev/null 2>&1 &
    scan_pid=$!
fi

networks=$(
    nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list |
    awk -F: '
    NF >= 4 && $2 != "" {
        active = ($1 == "*" ? "✓" : " ")
        lock = ($4 == "--" || $4 == "" ? "󰖩" : "󰌾")
        printf "%s  %s  %s%%  %s\n", active, $2, $3, lock
    }' |
    sort -u
)

choice=$(
    printf '%s\n' "$networks" |
    fuzzel --dmenu --prompt="Wi-Fi > "
)

[ -z "$choice" ] && exit 0

ssid=$(
    printf '%s\n' "$choice" |
    sed -E 's/^[✓ ]+[[:space:]]+//' |
    sed -E 's/[[:space:]]+[0-9]+%[[:space:]]+.*$//'
)

current=$(
    nmcli -t -f ACTIVE,SSID device wifi |
    awk -F: '$1=="yes" { print $2; exit }'
)

[ "$ssid" = "$current" ] && exit 0

if nmcli connection up id "$ssid" >/dev/null 2>&1; then
    exit 0
fi

# Если был фоновый scan — дожидаемся его
[ -n "$scan_pid" ] && wait "$scan_pid" 2>/dev/null

password=$(
    fuzzel \
        --dmenu \
        --password \
        --prompt="Password for $ssid > " < /dev/null
)

[ -z "$password" ] && exit 0

nmcli device wifi connect "$ssid" password "$password"
