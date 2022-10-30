#!/usr/bin/env bash

pid=$(pgrep --full 'alacrittydropdown --class alacrittydropdown')

if [ -n "$pid" ] ; then
    kill "$pid"
else
    WAYLAND_DISPLAY='' $TERMINAL \
        --title 'alacrittydropdown' \
        --class 'alacrittydropdown' \
        -e bash -c "(tmux ls | grep -qEv 'dropdown' && tmux -u attach-session -t dropdown) || tmux -u new -s dropdown"
fi
