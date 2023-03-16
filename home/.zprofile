# Only loaded from login shell

# NOTE: Refer .zshenv for detail.
if [ -d "$HOME/.anyenv" ]; then
    export PATH="$HOMEBREW_PATH/bin:$PATH"
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init - --no-rehash zsh)"
fi
