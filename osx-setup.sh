#!/bin/zsh
# helper functions

set -e
eval $(ssh-agent -s)

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap Homebrew/bundle
brew bundle

# rust
curl https://sh.rustup.rs -sSf | sh

# vim configs + install
rm -rf ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/temp_dirs/undodir
cp vim-configs/my_configs.vim $HOME/.vim/
cp vim-configs/plugin_configs.vim $HOME/.vim/
cp vim-configs/vimrc $HOME/.vimrc
vim +PlugInstall +qall

# fzf
rm -rf "$HOME/.fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

# git
cp .gitconfig "$HOME/.gitconfig"

# zsh configs + install
chsh -s $(which zsh)
rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

cp j.zsh-theme $HOME/.oh-my-zsh/themes/j.zsh-theme
cp .zshrc "$HOME/.zshrc"
cp .zsh_aliases "$HOME/.zsh_aliases"

# tmux
cp .tmux.conf "$HOME/.tmux.conf"
[ ! -d "$HOME/.tmux" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

source "$HOME/.zshrc"
