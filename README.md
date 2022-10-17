# J's dotfiles setup for a Ubuntu 18.04 machine

## Installation Notes

- The `personalize` script in coder isn't running `chown` correctly, so you must run manually after jumping on the box
```bash
sudo chown -R $(who | head -n 1 | awk '{print $1;}'): $HOME
```
- install `tmux` plugins after starting `tmux` for the first time with `bind-key + shift + i` (`Ctrl-a + I`)

## Installation

```bash
./install.sh
```

# TODO

- use antigen: https://phuctm97.com/blog/zsh-antigen-ohmyzsh
