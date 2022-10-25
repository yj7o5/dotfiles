#!/bin/zsh

sudo ./setup.sh

sudo chown -R $(who | head -n 1 | awk '{print $1;}'): $HOME

source $HOME/.zprofile
