#!/bin/zsh

sudo ./setup.sh

sudo chown -R $(who | head -n 1 | akw '{print $1;}'): $HOME
