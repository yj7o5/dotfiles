# place at ~/.tmux/plugins/tmux/custom/mynetwork.sh
show_mynetwork() { # This function name must match the module name!
  local index icon color text module

  index=$1 # This variable is used internally by the module loader in order to know the position of this module

  # color="$(get_tmux_option "@catppuccin_mynetwork_color" "$thm_green" )"
  # https://www.nerdfonts.com/cheat-sheet
  icon="$(get_tmux_option "@catppuccin_mynetwork_icon"  "#($HOME/dotfiles/mynetwork/icon.sh)")"
  color="$(get_tmux_option "@catppuccin_mynetwork_color" "#($HOME/dotfiles/mynetwork/color.sh)" )"
  text="$(get_tmux_option "@catppuccin_mynetwork_text" "#($HOME/dotfiles/mynetwork/text.sh)")"
  module=$(build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
