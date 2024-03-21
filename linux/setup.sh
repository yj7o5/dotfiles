#!/bin/zsh
# helper functions
# works on Ubuntu 22.04
sys_name=$(uname -s)
if [[ $sys_name == "Darwin" ]]; then
  echo 'only run this script on a Linux distro. This is a MacOS distro. rerun ./osx-setup.sh'
  exit 1
fi

set -e
eval $(ssh-agent -s)


# install pacakges
DEBIAN_FRONTEND=noninteractive xargs apt-get install -yq <apt-requirements.txt

# enable fd
ln -s $(which fdfind) /usr/local/bin/fd

# git
cp .gitconfig "$HOME/.gitconfig"

# nvim configs + install
git clone git@github.com:jayeve/nvim.git $HOME/.config/nvim

# fzf
rm -rf "$HOME/.fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

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

# neovim
# add-apt-repository ppa:neovim-ppa/unstable
curl -LO https://github.com/neovim/neovim/releases/download/v0.9.1/nvim.appimage
chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract
mv nvim.appimage $HOME/nvim.appimage
echo alias nvim="~/squashfs-root/usr/bin/nvim" >> ~/.zsh_aliases

# tmux
cp .tmux.conf "$HOME/.tmux.conf" && [ ! -d "$HOME/.tmux" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

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
