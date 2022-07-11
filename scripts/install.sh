#!/bin/bash -eux

# Run this with curl

# Also installs command line tools and git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

mkdir -p ~/.homeshick/repo
git clone git@github.com:ypresto/dotfiles ~/.homeshick/repo/dotfiles

cd ~/.homeshick/repo/dotfiles
bash scripts/setup.sh
