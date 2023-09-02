#!/bin/sh
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm ~/.config/fish/config.fish

cp ./nvim ~/.config/nvim -r
cp ./fish/config.fish ~/.config/fish/config.fish

