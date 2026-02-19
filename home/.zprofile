# Only loaded from login shell

# NOTE: Refer .zshenv for detail.
export HOMEBREW_PATH=/opt/homebrew
export PATH="$HOMEBREW_PATH/bin:$PATH"
if [ -d "$HOME/.anyenv" ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init - --no-rehash zsh)"
fi
