# setup anyenv if exists
if [ -d "$HOME/.anyenv" ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

export LANG=en_US.UTF-8

export GOPATH="$HOME/go"
export PATH="bin:$HOME/bin:$DOTFILES_DIR/bin:$DOTFILES_DIR/node_modules/.bin:$GOPATH/bin:$PATH"
