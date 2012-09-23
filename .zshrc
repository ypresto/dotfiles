#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

if [ "$TERM" = "xterm" ]; then
    # No it isn't, it's gnome-terminal
    export TERM=xterm-256color
fi

#bindkey -v
bindkey -e

fpath=(~/.zsh/functions ~/homebrew/share/zsh/{site-,}functions /usr/local/share/zsh/{site-,}functions ${fpath})

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors


autoload -U +X bashcompinit && bashcompinit

source ~/.bashrc

# *** moved from .bashrc_public ***

if which gls >/dev/null 2>&1; then
    # os x with homebrew/coreutils
    alias ls='gls --color=auto'
    eval `gdircolors ~/dotfiles/dircolors-solarized/dircolors.ansi-dark`
elif [ -d /Library ]; then
    # os x without homebrew/coreutils
    alias ls='ls -G'
else
    # maybe linux
    alias ls='ls --color=auto'
    eval `dircolors ~/dotfiles/dircolors-solarized/dircolors.ansi-dark`
fi

if which gfind >/dev/null 2>&1; then
    alias find='gfind'
fi

# color / ignore case
alias less='less -Ri'

# ENV
export PATH="$HOME/dotfiles/node_modules/.bin:$PATH"
export EDITOR=vim
export CLICOLOR=YES

# deprecated by byobu-reconnect-session
# # for detach screen/tmux/byobu with ssh-agent
# ssh_auth_sock_path=~/.ssh/ssh_auth_sock
# if [ $SSH_AUTH_SOCK != $ssh_auth_sock_path ]; then
#     ln -sf $SSH_AUTH_SOCK $ssh_auth_sock_path
#     export SSH_AUTH_SOCK=$ssh_auth_sock_path
# fi

# *** config by r7kamura ***

autoload -U colors
colors
autoload -U add-zsh-hook
autoload -Uz vcs_info
autoload -U compinit
autoload history-search-end

# util
# http://www.logilab.org/blogentry/20255
function ext_color () { echo -ne "\033[38;5;$1m"; }

unset CONFIG_PROMPT_COLOR
# host local config
if [ -f "$HOME/.zshrc_config" ]; then
    source "$HOME/.zshrc_config"
fi
CONFIG_PROMPT_COLOR=${CONFIG_PROMPT_COLOR-$fg[red]}

# Prompt
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "+"
zstyle ':vcs_info:git:*' unstagedstr "-"
zstyle ':vcs_info:git:*' formats '(%b)%c%u'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)%c%u'
function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
#PROMPT="%{${fg[yellow]}%}✘╹◡╹✘%{${reset_color}%} "
PROMPT2="%{${fg[blue]}%}%_> %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
VCS_PROMPT="%1(v|%F{green} %1v%f|)"
DIR_PROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
RPROMPT="$VCS_PROMPT $DIR_PROMPT"

setopt auto_cd
setopt auto_pushd

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history
setopt hist_expand
setopt hist_ignore_all_dups
setopt hist_ignore_space
#bindkey -e
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

compinit
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' max-errors 50
zstyle ':completion:*' list-colors ''
zstyle :compinstall filename "$HOME/.zshrc"

if zle -la | grep -q '^history-incremental-pattern-search'; then
  bindkey '^R' history-incremental-pattern-search-backward
  bindkey '^S' history-incremental-pattern-search-forward
fi

# Move each word to press Ctrl + Arrow-key
bindkey ";5C" forward-word
bindkey ";5D" backward-word

alias g="git"
alias v='vim "$@"'
alias V='mvi "$@"'
alias d='git diff'
alias c='git diff --cached'
alias s='git status --short'
alias t='tig'
alias p='popd'
alias :q='exit'
alias :z='v ~/dotfiles/.zshrc'
alias :zz='. ~/.zshrc'
alias :b='v ~/dotfiles/.bashrc_public'
alias :B='v ~/.bashrc'
alias :bb='. ~/.bashrc'
alias :v='v ~/dotfiles/.vimrc'
alias :V='V ~/dotfiles/.vimrc'
alias :gc='v ~/dotfiles/.gitconfig'
alias :d='cd ~/dotfiles'
alias :h=' \
    [ -d ~/homebrew ] && cd ~/homebrew || \
    [ -d /usr/local ] && cd /usr/local || \
    echo "no homebrew" >&2 && return 1'
alias :g='cd ~/repo/github.com'
alias :bl='v ~/.bashrc'
#alias snip='open ~/.vim/bundle/snipMate/snippets'
a() { 1=${1:--A}; git add $*; git status --short }
m() { git commit -m "$*" }

copy-line() { print -rn $BUFFER | pbcopy; zle -M "Copied: ${BUFFER}" }
zle -N copy-line
#bindkey '\@' copy-line

#zshプロンプトにモード表示####################################
# PROMPT="%{$fg[red]%}[%{$reset_color%}%n%{$fg[red]%}]%#%{$reset_color%} " # username pattern
PROMPT="%{$CONFIG_PROMPT_COLOR%}[%{$reset_color%}${HOST%%.*}%{$CONFIG_PROMPT_COLOR%}]%#%{$reset_color%} " # hostname pattern
if false; then
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
    PROMPT="%{$CONFIG_PROMPT_COLOR%}[%{$reset_color%}%n/%{$fg_bold[red]%}NOR%{$reset_color%}%{$CONFIG_PROMPT_COLOR%}]%#%{$reset_color%} "
    ;;
    main|viins)
    PROMPT="%{$CONFIG_PROMPT_COLOR%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$CONFIG_PROMPT_COLOR%}]%#%{$reset_color%} "
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
fi

bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^U" vi-kill-line
# wrong mappings
# bindkey "^[;3C" forward-word
# bindkey "^[;3D" backward-word

# http://gry.sakura.ne.jp/2009/06/08/183
bindkey "^H"    backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

# Release Ctrl-Q and Ctrl-S from tty
stty stop undef
stty start undef

alias vless='/usr/share/vim/vim73/macros/less.sh'

export WORDCHARS='*?_[]~=&;!#$%^(){}-'


# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

#=============================
# source auto-fu.zsh
#=============================
source ~/dotfiles/auto-fu.zsh/auto-fu.zsh
function zle-line-init () {
    auto-fu-init
}
zle -N zle-line-init
zstyle ':completion:*' completer _oldlist _complete

# zaw.zsh
# FIXME: conflicts with auto-fu, use Ctrl-C to avoid
source ~/dotfiles/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes
bindkey '^V' zaw-cdr
bindkey '^O' zaw-git-files

unsetopt list_beep
unsetopt beep
# bindkey -M afu '^[' afu+cancel # conflicts with ^[[Z
bindkey -M afu '^G' afu+cancel
bindkey '^[[Z' reverse-menu-complete
# bindkey -M afu "^J" afu+cancel afu+accept-line
# bindkey -M afu "^M" afu+cancel afu+accept-line

source_homebrew () {
    for dir in ~/homebrew /usr/local; do
        [ -f $dir/$1 ] && source $dir/$1 && return
    done
    echo "could not load $1" >&2
    return 1
}

# git completion
source ~/dotfiles/bash-completion/git-completion.bash
# hub completion
source_homebrew etc/bash_completion.d/hub.bash_completion.sh
eval "$(hub alias -s zsh)"

# for ubuntu
if which ack-grep >/dev/null 2>&1; then
    alias ack='ack-grep'
    # compdef ack-grep=ack
fi

# Refer: http://d.hatena.ne.jp/namutaka/20100118/1263830555
# .zshrc
# command "mvi"
function mvi() {
    if [ $# != 0 ]; then
        mvim --remote-tab-silent $@ 2> /dev/null
    else
        srvs=`mvim --serverlist 2> /dev/null`
        if [ "$srvs" != "" ]; then
            mvim --remote-send "<Esc>:tabnew<CR>"
        else
            mvim
        fi
    fi
}

alias mvimcd="mvim -c 'cd \`pwd\`'"
cl () { cd $1; ls }

# temp
alias mvim=gvim
alias gvi=mvi

source $HOME/.zshrc_local

if [ "$BYOBU_BACKEND" = "tmux" ]; then
    # work arround for automatic-rename local option is set by someone
    tmux set-window-option -u automatic-rename
fi
