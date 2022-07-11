#!/bin/bash -eux

# Run this with curl

# Also installs command line tools and git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

git clone git@github.com:ypresto/dotfiles ~/.dotfiles

cd ~/.dotfiles
bash scripts/setup.sh
