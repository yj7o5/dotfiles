#!/bin/zsh

# inspiration: https://github.com/catppuccin/tmux/issues/90#issuecomment-1961298007
get_current_network_icon() {
  if [[ "$(uname)" == "Darwin" ]]; then
    current_network="$(networksetup -getairportnetwork en0 | awk -F: '{gsub(/^ *| *$/, "", $2); print $2}')"
    if [[ -z $current_network ]]; then
      echo "󰖪"
    else
      echo "󱚽"
    fi
  else
    echo "󱚵"
  fi
}

get_current_network_icon
