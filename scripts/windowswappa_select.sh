#!/bin/bash

mode=$1 # -S to swap, nothing to detach
client_list=$(hyprctl clients -j | jq '[.[] | select(.workspace.id==10)]')
cw=$(hyprctl activewindow -j)
cw_addr=$(hyprctl activewindow -j | jq -r ".address")
cw_workspace=$(hyprctl activeworkspace -j | jq -r ".id")
cw_x=$(echo "$cw" | jq ".at[0]")
cw_y=$(echo "$cw" | jq ".at[1]")
cw_w=$(echo "$cw" | jq ".size[0]")
cw_h=$(echo "$cw" | jq ".size[1]")



selection=$((echo "$client_list" | jq -r '.[] | "[\(.class)] - \(.title) (\(.address))"') | rofi -dmenu --p "W1nd0w Sw4p4")

[ -z "$selection" ] && exit 0

addr=$(echo "$selection" | awk -F '[()]' '{print $2}')
echo "$addr"

hyprctl dispatch resizewindowpixel exact "$cw_w" "$cw_h,address:$addr"
hyprctl dispatch movewindowpixel exact "$cw_x" "$cw_y," address:"$addr"
hyprctl dispatch movetoworkspace "$cw_ws,address:$addr"
hyprctl dispatch togglefloating address:$addr

if [[ "$mode" == "-S" ]]; then
  hyprctl dispatch togglefloating address:$cw_addr
  hyprctl dispatch resizewindowpixel exact "$cw_w" "$cw_h,address:$addr"
  hyprctl dispatch movewindowpixel exact "$cw_x" "$cw_y," address:"$cw_addr"
  hyprctl dispatch movetoworkspacesilent "10,address:$cw_addr"
fi

hyprctl dispatch focuswindow address:$addr
