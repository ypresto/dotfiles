# NOTE: Refer .zshenv for detail.
if [[ -o login ]]; then
  # setup anyenv if exists
  if [ -d "$HOME/.anyenv" ]; then
      export PATH="$HOME/.anyenv/bin:$PATH"
      eval "$(anyenv init -)"
  fi
fi

