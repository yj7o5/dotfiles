#!/bin/zsh
# helper functions

set -e
eval $(ssh-agent -s)

# install pacakges
add-apt-repository -y ppa:jonathonf/vim && apt-get update -yqq
DEBIAN_FRONTEND=noninteractive xargs apt-get install -yqq <apt-requirements.txt

# vim configs + install
rm -rf ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/temp_dirs/undodir
cp vim-configs/my_configs.vim $HOME/.vim/
cp vim-configs/plugin_configs.vim $HOME/.vim/
cp vim-configs/vimrc $HOME/.vimrc
vim +PlugInstall +qall

# ripgrep
RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "\K[0-9.]+')
curl -Lo ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_${RIPGREP_VERSION}_amd64.deb"
dpkg -i ripgrep.deb
rm ripgrep.deb

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

# zsh plugin: fzf-tab must be after oh-my-zsh is installed
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab

# zsh plugin: fzf-tab must be after oh-my-zsh is installed
git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/k

cp j.zsh-theme $HOME/.oh-my-zsh/themes/j.zsh-theme
cp .zshrc "$HOME/.zshrc"
cp .zprofile "$HOME/.zprofile"
cp .zsh_aliases "$HOME/.zsh_aliases"

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# tmux
cp .tmux.conf "$HOME/.tmux.conf"
[ ! -d "$HOME/.tmux" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

# helpful functions
cp .work_functions.zsh "$HOME/.work_functions.zsh"

## random installs not easily available on apt repositories

yarn global add stylelint

# loc (lines-of-code)
cargo install loc

# helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm
