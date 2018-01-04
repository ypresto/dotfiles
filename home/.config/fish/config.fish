set DOTFILES_PATH "$HOME/.homesick/repos/dotfiles"

source "$HOME/.homesick/repos/homeshick/homeshick.fish"

source "$DOTFILES_PATH/aliases.sh"

function fish_user_key_bindings
  bind \cr peco_select_history
end
