source $HOME/.byobu_keybindings

unbind-key -n C-a
unbind-key -n C-t
set -g prefix ^T
set -g prefix2 ^T
bind t send-prefix
