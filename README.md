# J's dotfiles setup for a Ubuntu 18.04 machine

## Installation Notes

- The `personalize` script in coder isn't running `chown` correctly, so you must run manually after jumping on the box
```bash
sudo chown -R $(who | head -n 1 | awk '{print $1;}'): $HOME
```

## Installation

```bash
./install.sh
```
