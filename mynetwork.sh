# place at ~/.tmux/plugins/tmux/custom/mynetwork.sh

get_current_network() {
  if [[ "$(uname)" == "Darwin" ]]; then
    networksetup -getairportnetwork en0 | awk -F: '{gsub(/^ *| *$/, "", $2); print $2}'
  else
    echo "ERR: Not OSX"
  fi
}

print_current_network() {
  local char_limit current_network
  char_limit=$(get_tmux_option @current-network-char-limit 75)
  current_network=$(get_current_network)
  echo "${current_network:0:$char_limit}"
}

show_mynetwork() { # This function name must match the module name!
  local index current_network icon color text module

  index=$1 # This variable is used internally by the module loader in order to know the position of this module
  current_network="$(print_current_network)"

  icon="$(  get_tmux_option "@catppuccin_mynetwork_icon"  "🛜"           )"
  color="$( get_tmux_option "@catppuccin_mynetwork_color" "$thm_green" )"
  text="$(  get_tmux_option "@catppuccin_mynetwork_text"  "$current_network" )"

  module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
