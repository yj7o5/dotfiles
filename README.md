# J's dotfiles setup for a Ubuntu 22.04 machine

## TODO

- Add `airport` and `ping` to tmux bar

## Installation Notes

- [linux] The `personalize` script in coder isn't running `chown` correctly, so you must run manually after jumping on the box

```bash
sudo chown -R $(who | head -n 1 | awk '{print $1;}'): $HOME
```

- install `tmux` plugins after starting `tmux` for the first time with `bind-key + shift + i` (`Ctrl-a + I`)
- reload `tmux` by running `bind-key + shift + r` (`Ctrl-a + R`)
- add the tpm tmux plugin manager

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Installation

```bash
./install.sh
```

## NVIM Installation

- nvim 0.10.0 doesn't seem to work as of Aug 2023, so try installing 0.9.1 [via appimage](https://github.com/neovim/neovim/wiki/Installing-Neovim)

```bash
cd ~
curl -LO https://github.com/neovim/neovim/releases/download/v0.9.1/nvim.appimage
chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract
echo alias nvim="~/squashfs-root/usr/bin/nvim" >> ~/.zsh_aliases
```

- in nvim, run 'TSInstall python'

- make sure you're on Neovim v 0.8 +

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
```

- open and save the `plugin-setup.lua` file to force install of all the goodies

# TODO

- use antigen: https://phuctm97.com/blog/zsh-antigen-ohmyzsh

## Karabiner complex key commands

- https://ke-complex-modifications.pqrs.org/?q=media%20keys (Standard media control keys using the fn key)
- switch colon with semicolon
- swith left/right option with left/right command (windows mode)

# Network Uilities

```
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport
```

run it

```
airport --scan | tail -n +2 | awk -F' {2,}' '{print $3, $2}' |sort
```

## Work (coder)

- Check nvim version with `nvim --version` and make sure you're on nvim 0.5.0+. this typically requires a non-standard installation (different apt repository)
- make sure `home/discord/.config/nvim` is tracking this upstream source. If not, delete it and run `git clone git@github.com:discord/discord`.
- open `/home/discord/.config/nvim/lua/jayeve/plugins-setup.lua`, change something, and save. This will force an install of all plugins
