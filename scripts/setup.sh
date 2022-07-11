#!/bin/bash -eux

brew install git zsh anyenv # minimum tools

rm -rf ~/.homesick/repos/homeshick
mkdir -p ~/.homesick/repos
git clone https://github.com/andsens/homeshick.git ~/.homesick/repos/homeshick

rm -f ~/.homesick/repos/dotfiles
ln -s ../../.dotfiles ~/.homesick/repos/dotfiles
~/.homesick/repos/homeshick/bin/homeshick link -f --verbose dotfiles

rm -rf ~/.zinit/bin
mkdir -p ~/.zinit
git clone https://github.com/zdharma/zinit.git ~/.zinit/bin

/opt/homebrew/bin/zsh -ic 'echo Zsh initial run succeeded.'
sudo chsh -s /opt/homebrew/bin/zsh $USER

# Create anyenv dir
echo y | anyenv install --init

echo 'Completed. Run brew bundle --global ?'
