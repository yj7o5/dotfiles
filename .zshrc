source_if_exists() {
  [[ -s $1 ]] && source $1
}

# profile startup
zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(docker docker-compose fzf)
# add the argument to $PATH only if it's not already present
function extend_path() {
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}
# source a script, if it exists

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="j"

# add ~/.local/bin to $PATH if it exists
[[ -d "$HOME/.local/bin" ]] && extend_path "$HOME/.local/bin"

# less
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# cross-platform clipboard
if which xclip > /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

source_if_exists "$ZSH/oh-my-zsh.sh"
source_if_exists "$HOME/.zsh_aliases"
source_if_exists "$HOME/.work_functions.zsh"
source_if_exists "$HOME/.fzf.zsh"
