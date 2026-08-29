#!/usr/bin/env bash

cpu=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.0f", 100 - $8}')

mem=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

printf ' %s%%   %s%%\n' "$cpu" "$mem"
