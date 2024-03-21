# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/jevans/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/jevans/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/Users/jevans/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/Users/jevans/.fzf/shell/key-bindings.zsh"
