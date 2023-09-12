# add the argument to $PATH only if it's not already present
function extend_path() {
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

# source a script, if it exists
function source_if_exists() { [[ -s $1 ]] && source $1 || true }

# profile startup
zmodload zsh/zprof

# less
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source_if_exists $ZSH/oh-my-zsh.sh

# zoxide for quicker directory changes
autoload -Uz compinit
compinit -i
# add ~/.local/bin to $PATH if it exists. necessary for zoxide
[[ -d "$HOME/.local/bin" ]] && extend_path "$HOME/.local/bin"

eval "$(zoxide init zsh)"

plugins=(
  git
  docker
  docker-compose
  fzf
  # fzf-tab
  k
  zsh-autosuggestions
  fast-syntax-highlighting
)

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="j"

# cross-platform clipboard
if which xclip > /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

#if which rg > /dev/null; then export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc; fi

source_if_exists "$HOME/.gvm/scripts/gvm"
source_if_exists "$HOME/.iterm2_shell_integration.zsh"
source_if_exists "$HOME/.nix-profile/etc/profile.d/nix.sh"

source_if_exists "$HOME/.work_functions.zsh"
source_if_exists "$HOME/.zsh_aliases"
source_if_exists "$HOME/.aws/token_profile"

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local __files
  OLDIFS=$IFS
  IFS=$'\n' __files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$__files" ]] && ${EDITOR:-vim} "${__files[@]}" && IFS=$OLDIFS || IFS=$OLDIFS
}

# fd [FUZZY PATTERN] - Open the selected folder
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fdd() {
  local __file
  local __dir
  __file=$(fzf +m -q "$1") && __dir=$(dirname "$__file") && cd "$__dir"
}

# airport network utility
sys_name==$(uname -s)
if [[ $sys_name == "Darwin" ]]; then
  ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport
elif [[ $sys_name == "Linux" ]]; then
  echo "airport not supported on Linux" 
else
  echo "Unknown system. sorry Windows"
