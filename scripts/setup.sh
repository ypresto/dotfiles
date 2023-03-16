#!/bin/bash -eux

HOMEBREW_PATH=${HOMEBREW_PATH:-/opt/homebrew}

PATH="$HOMEBREW_PATH/bin:${PATH}"

brew install git zsh anyenv # minimum tools

rm -rf ~/.homesick/repos/homeshick
mkdir -p ~/.homesick/repos
git clone https://github.com/andsens/homeshick.git ~/.homesick/repos/homeshick

rm -f ~/.homesick/repos/dotfiles
ln -s ../../.dotfiles ~/.homesick/repos/dotfiles
~/.homesick/repos/homeshick/bin/homeshick link -f --verbose dotfiles

NO_INPUT=1 NO_ANNEXES=1 NO_EDIT=1 bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

$HOMEBREW_PATH/bin/zsh -ic 'echo Zsh initial run succeeded.'
sudo chsh -s $HOMEBREW_PATH/bin/zsh $USER

# Create anyenv dir
echo y | anyenv install --init

# Install vim package manager
git clone https://github.com/Shougo/dein.vim.git ~/.vim/dein/repos/github.com/Shougo/dein.vim
NO_VIMRC=1 vim +'call dein#install()' +qall

echo 'Completed. Run brew bundle --global ?'
