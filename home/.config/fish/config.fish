set -x DOTFILES_PATH "$HOME/.homesick/repos/dotfiles"

source "$HOME/.homesick/repos/homeshick/homeshick.fish"

source "$DOTFILES_PATH/aliases.sh"

function fish_user_key_bindings
  bind \cr peco_select_history
end

# https://github.com/fish-shell/fish-shell/issues/825#issuecomment-226646287
function sync_history --on-event fish_preexec
    history --save
    history --merge
end
