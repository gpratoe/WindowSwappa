#!/bin/bash

mode=$1 # -N to next, nothing to go back and forth with the last one

client_list=$(hyprctl clients -j | jq '[.[] | select(.workspace.id==10)] | sort_by(.focusHistoryID)')
cw=$(hyprctl activewindow -j)
cw_addr=$(hyprctl activewindow -j | jq -r ".address")
cw_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
cw_x=$(echo "$cw" | jq ".at[0]")
cw_y=$(echo "$cw" | jq ".at[1]")
cw_w=$(echo "$cw" | jq ".size[0]")
cw_h=$(echo "$cw" | jq ".size[1]")

len=$(echo "$client_list" | jq length)

[ "$len" -eq 0 ] && exit 0

if [[ "$mode" == "-N" ]]; then
  ind=$((len - 1))
else
  ind=0
fi

addr=$(echo "$client_list" | jq -r ".[$ind].address")
hyprctl dispatch resizewindowpixel exact "$cw_w" "$cw_h,address:$addr"
hyprctl dispatch movewindowpixel exact "$cw_x" "$cw_y," address:"$addr"
hyprctl dispatch movetoworkspace "$cw_workspace,address:$addr"
hyprctl dispatch togglefloating address:$addr

hyprctl dispatch togglefloating address:$cw_addr
hyprctl dispatch resizewindowpixel exact "$cw_w" "$cw_h,address:$addr"
hyprctl dispatch movewindowpixel exact "$cw_x" "$cw_y," address:"$cw_addr"
hyprctl dispatch movetoworkspacesilent "10,address:$cw_addr"

hyprctl dispatch focuswindow address:$addr
