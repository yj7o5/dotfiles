#!/bin/zsh

# inspiration: https://github.com/catppuccin/tmux/issues/90#issuecomment-1961298007
# thm_bg="#303446"
# thm_fg="#c6d0f5"
# thm_cyan="#99d1db"
# thm_black="#292c3c"
# thm_gray="#414559"
# thm_magenta="#ca9ee6"
# thm_pink="#f4b8e4"
# thm_red="#e78284"
# thm_green="#a6d189"
# thm_yellow="#e5c890"
# thm_blue="#8caaee"
# thm_orange="#ef9f76"
# thm_black4="#626880"
get_current_network_color() {
  if [[ "$(uname)" == "Darwin" ]]; then
    # current_network="$(networksetup -getairportnetwork en0 | awk -F: '{gsub(/^ *| *$/, "", $2); print $2}')"
    current_network="$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}')"
    if [[ -z $current_network ]]; then
      echo '#414559'
    else
      echo '#a6d189'
    fi
  else
    echo "orange"
  fi
}

get_current_network_color
