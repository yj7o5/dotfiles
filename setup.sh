#!/bin/zsh
# helper functions

set -e
eval $(ssh-agent -s)

# install pacakges
add-apt-repository -y ppa:jonathonf/vim && apt-get update -yqq
DEBIAN_FRONTEND=noninteractive xargs apt-get install -yqq <zsh-requirements.txt

# vim configs + install
rm -rf ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/temp_dirs/undodir
cp vim-configs/my_configs.vim $HOME/.vim/
cp vim-configs/plugin_configs.vim $HOME/.vim/
cp vim-configs/vimrc $HOME/.vimrc
vim +PlugInstall +qall

# tmux
cp .tmux.conf "$HOME/.tmux.conf"

# ripgrep
RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "\K[0-9.]+')
curl -Lo ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_${RIPGREP_VERSION}_amd64.deb"
dpkg -i ripgrep.deb
rm ripgrep.deb

# fzf
rm -rf "$HOME/.fzf"
#git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
#$HOME/.fzf/install --all

# git
cp .gitconfig "$HOME/.gitconfig"

# zsh configs + install
chsh -s $(which zsh)
rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

cp j.zsh-theme $HOME/.oh-my-zsh/themes/j.zsh-theme
cp .zshrc "$HOME/.zshrc"
cp .zsh_aliases "$HOME/.zsh_aliases"

# install antigen
#source /usr/share/zsh-antigen/antigen.zsh
#antigen use oh-my-zsh
#antigen bundle git
#antigen bundle composer
#antigen bundle zsh-users/zsh-syntax-highlighting
#antigen theme agnoster #you need to install powerline fonts for this theme (apt-get install powerline)
#antigen apply

source "$HOME/.zshrc"
