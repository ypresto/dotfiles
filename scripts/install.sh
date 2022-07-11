#!/bin/bash -eux

# Run this with curl

# Also installs command line tools and git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

mkdir -p ~/.homeshick/repo
git clone git@github.com:ypresto/dotfiles ~/.homeshick/repo

cd ~/.homeshick/repo/dotfiles
scripts/setup
