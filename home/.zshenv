export LANG=en_US.UTF-8

export ANDROID_HOME="$HOME/.android-sdk"
export GOPATH="$HOME/go"

path=(
  $ANDROID_HOME/platform-tools
  $GOPATH/bin
  $path
)

if [ -d "$HOME/.anyenv" ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - --no-rehash zsh)"
fi
