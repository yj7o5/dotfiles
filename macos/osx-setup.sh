#!/bin/zsh
# helper functions

set -e
eval $(ssh-agent -s)

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap Homebrew/bundle
brew bundle

# install language servers necessary for neovim LSP
npm install typescript-language-server tailwindcss-language-server

# rust
curl https://sh.rustup.rs -sSf | sh

# fzf
rm -rf "$HOME/.fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all

# fzf-tab
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab

# zsh plugin: fzf-tab must be after oh-my-zsh is installed
git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/k

# git
cp .gitconfig "$HOME/.gitconfig"

# zsh configs + install
chsh -s $(which zsh)
rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

cp yawar.zsh-theme $HOME/.oh-my-zsh/themes/yawar.zsh-theme
cp .zshrc "$HOME/.zshrc"
cp .zsh_aliases "$HOME/.zsh_aliases"

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# tmux
cp .tmux.conf.osx "$HOME/.tmux.conf"
[ ! -d "$HOME/.tmux" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

# helpful functions
cp .work_functions.zsh "$HOME/.work_functions.zsh"

# # misc
# yarn global add stylelint

# nerd font setup -- https://www.josean.com/posts/terminal-setup
curl https://raw.githubusercontent.com/josean-dev/dev-environment-files/main/coolnight.itermcolors --output ~/Downloads/coolnight.itermcolors

source "$HOME/.zshrc"
