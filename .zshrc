# add the argument to $PATH only if it's not already present
function extend_path() {
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

# default editor
export EDITOR=$(which nvim)
export XDG_CONFIG_HOME="$HOME/.config"

# use neovim as manpager
export MANPAGER='nvim +Man!'
export MANWIDTH=80

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
  kubectl
  kubectx
  # fzf-tab
  zsh-autosuggestions
  fast-syntax-highlighting
)

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="yawar"

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

function ff {
  result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
    fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
  file=${result%%:*}
  linenumber=$(echo "${result}" | cut -d: -f2)
  if [[ -n "$file" ]]; then
          $EDITOR +"${linenumber}" "$file"
  fi
}

function tm() {
  current_directory=$(basename "$PWD")
  # check if we're currently in a TMUX session
  if [[ -n $TMUX ]]; then
    current_session=$(tmux display-message -p '#S')
    echo "current session" $current_session
    if [[ "$current_session" == "$current_directory" ]]; then
      echo "No-op"
      return
    fi
  fi
  echo "checking for session" $current_directory
  tmux has-session -t $current_directory 2>/dev/null && tmux attach-session -t $current_directory || tmux new-session -d -s $current_directory
  # if we get to this line, we must not have switched sessions
  tmux switch-client -t $current_directory
}

gch () {
  git recent | \
    fzf-tmux --ansi --border \
      --color='info:143,border:240,spinner:108,hl+:red' \
      --delimiter ' | ' | \
    sed 's/^[ \t*]*//' | \
    awk '{print $1}' | \
    xargs git checkout
}

export DOCKER_DEFAULT_PLATFORM=linux/amd64

# init startship enhanced cmd prompt
eval "$(starship init zsh)"
