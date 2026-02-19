# This file is loaded before ~/.zprofile

export LANG=en_US.UTF-8

export ANDROID_HOME=/usr/local/share/android-sdk
export GOPATH="$HOME/go"

path=(
  $ANDROID_HOME/platform-tools
  $GOPATH/bin
  $path
)

# NOTE: OS X precedes PATHs like /usr/bin in /etc/profile.
# So bins in homebrew won't be used if same command is in /usr/bin.
# For workaround, skip for login shell here and call later in .zprofile .
# This is for interactive shell and script.
# http://masasuzu.hatenablog.jp/entry/20120506/1336286016
if ! [[ -o login ]]; then
    export HOMEBREW_PATH=/opt/homebrew
    export PATH="$HOMEBREW_PATH/bin:$PATH"
    # setup anyenv if exists
    if [ -d "$HOME/.anyenv" ]; then
        export PATH="$HOME/.anyenv/bin:$PATH"
        eval "$(anyenv init - --no-rehash zsh)"
    fi
fi
