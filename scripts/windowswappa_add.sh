#!/bin/bash

addr=$(hyprctl activewindow -j | jq -r ".address")
title=$(hyprctl activewindow -j | jq -r ".title")

hyprctl dispatch movetoworkspacesilent "10,address:$addr"
hyprctl dispatch togglefloating address:$addr
