export LANG=en_US.UTF-8

export ANDROID_HOME="$HOME/.android-sdk"
export GOPATH="$HOME/go"

path=(
  $ANDROID_HOME/platform-tools
  $GOPATH/bin
  $path
)

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
