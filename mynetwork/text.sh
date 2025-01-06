#!/bin/zsh

# inspiration: https://github.com/catppuccin/tmux/issues/90#issuecomment-1961298007
get_current_network_text() {
  if [[ "$(uname)" == "Darwin" ]]; then
    # current_network="$(networksetup -getairportnetwork en0 | awk -F: '{gsub(/^ *| *$/, "", $2); print $2}')"
    current_network="$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}')"
    if [[ -z $current_network ]]; then
      echo 'disconnected'
    else
      echo "$current_network"
    fi
  else
    echo "ERR: Not OSX"
  fi
}

get_current_network_text
