export DOTFILES_DIR="$HOME/.homesick/repos/dotfiles"

# NOTE: OS X precedes PATHs like /usr/bin in /etc/profile.
# Skip for login shell here and call later in .zprofile .
# http://masasuzu.hatenablog.jp/entry/20120506/1336286016
if ! [[ -o login ]]; then
  # setup anyenv if exists
  if [ -d "$HOME/.anyenv" ]; then
      export PATH="$HOME/.anyenv/bin:$PATH"
      eval "$(anyenv init -)"
  fi
fi


export LANG=en_US.UTF-8

export GOPATH="$HOME/go"
export PATH="$HOME/bin:$DOTFILES_DIR/bin:$DOTFILES_DIR/node_modules/.bin:$GOPATH/bin:$PATH"
