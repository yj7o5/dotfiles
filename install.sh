#!/bin/zsh
# helper functions

set -e

source_if_exists() {
  [[ -s $1 ]] && source $1
}

# install pacakges
add-apt-repository ppa:jonathonf/vim && apt-get update -yqq
DEBIAN_FRONTEND=noninteractive xargs sudo apt-get install -yqq <zsh-requirements.txt

# vim configs + install
rm -rf ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/temp_dirs/undodir
cp vim-configs/my_configs.vim $HOME/.vim/
cp vim-configs/plugin_configs.vim $HOME/.vim/
cp vim-configs/vimrc $HOME/.vimrc
vim +PlugInstall +qall

# zsh configs + install
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cp .zshrc "$HOME/.zshrc"
cp .zsh_aliases "$HOME/.zsh_aliases"

cp j.zsh-theme $HOME/.oh-my-zsh/themes/j.zsh-theme

source_if_exists "$HOME/.zshrc"
source_if_exists "$HOME/.zsh_aliases"
source_if_exists "$HOME/.gvm/scripts/gvm"
source_if_exists "$HOME/.iterm2_shell_integration.zsh"
source_if_exists "$HOME/.nix-profile/etc/profile.d/nix.sh"
source_if_exists "$HOME/.zsh_aliases"
source_if_exists "$HOME/.work_functions.zsh"

# tmux
cp .tmux.conf "$HOME/.tmux.conf"
source_if_exists "$HOME/.tmux.conf"

# ripgrep
RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "\K[0-9.]+')
curl -Lo ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_${RIPGREP_VERSION}_amd64.deb"
dpkg -i ripgrep.deb

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all
cp .fzf.zsh "$HOME/.fzf.zsh"
source_if_exists "$HOME/.fzf.zsh"

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
fd() {
  local __file
  local __dir
  __file=$(fzf +m -q "$1") && __dir=$(dirname "$__file") && cd "$__dir"
}

# git
cp .gitconfig "$HOME/.gitconfig"
