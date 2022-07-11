#!/bin/bash -eux

PATH="/opt/homebrew/bin:${PATH}"

brew install git zsh anyenv # minimum tools

rm -rf ~/.homesick/repos/homeshick
mkdir -p ~/.homesick/repos
git clone https://github.com/andsens/homeshick.git ~/.homesick/repos/homeshick

rm -f ~/.homesick/repos/dotfiles
ln -s ../../.dotfiles ~/.homesick/repos/dotfiles
~/.homesick/repos/homeshick/bin/homeshick link -f --verbose dotfiles

NO_INPUT=1 NO_ANNEXES=1 NO_EDIT=1 bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

/opt/homebrew/bin/zsh -ic 'echo Zsh initial run succeeded.'
sudo chsh -s /opt/homebrew/bin/zsh $USER

# Create anyenv dir
echo y | anyenv install --init

# Install vim package manager
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | bash -s ~/.vim/dein
NO_VIMRC=1 vim +'call dein#install()' +qall

echo 'Completed. Run brew bundle --global ?'
