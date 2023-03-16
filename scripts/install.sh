#!/bin/bash -eux

# Run this with curl

# Also installs command line tools and git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

git clone https://github.com/ypresto/dotfiles.git ~/.dotfiles

cd ~/.dotfiles
git remote set-url origin git@github.com:ypresto/dotfiles.git
bash scripts/setup.sh
