export LANG=en_US.UTF-8

export ANDROID_HOME=/usr/local/share/android-sdk
export GOPATH="$HOME/go"

path=(
  $ANDROID_HOME/platform-tools
  $GOPATH/bin
  $path
)

if [[ $(uname -m) == 'arm64' ]]; then
    export HOMEBREW_PATH='/opt/homebrew'
    path=(
        $HOMEBREW_PATH/bin
        $path
    )
else
    export HOMEBREW_PATH='/usr/local'
fi

# NOTE: OS X precedes PATHs like /usr/bin in /etc/profile.
# Skip for login shell here and call later in .zprofile .
# This is for interactive shell and script.
# http://masasuzu.hatenablog.jp/entry/20120506/1336286016
if ! [[ -o login ]]; then
    # setup anyenv if exists
    if [ -d "$HOME/.anyenv" ]; then
        export PATH="$HOME/.anyenv/bin:$PATH"
        eval "$(anyenv init - --no-rehash zsh)"
    fi
fi

if [ -f $HOME/.cargo ]; then
  . "$HOME/.cargo/env"
fi
