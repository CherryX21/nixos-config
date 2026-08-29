#!/usr/bin/env bash

exec swaylock \
    --screenshots \
    --effect-scale 0.5 \
    --effect-blur 7x5 \
    --effect-scale 2 \
    --effect-vignette 0.25:0.5 \
    --fade-in 0.25 \
    --clock \
    --timestr "%H:%M" \
    --datestr "%A, %d %B"
