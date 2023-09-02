#!/bin/sh
rm -rf ./nvim
rm ./fish/config.fish

cp ~/.config/nvim ./nvim -r
cp ~/.config/fish/config.fish ./fish/config.fish 
