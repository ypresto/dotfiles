#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

#bindkey -v
bindkey -e

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors


source ~/.bashrc

# *** config by r7kamura ***

autoload -U colors
autoload -U add-zsh-hook
autoload -Uz vcs_info
autoload -U compinit
autoload history-search-end

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
colors
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

# ENV
export PATH="$HOME/bin:$PATH"
export EDITOR=vim
export CLICOLOR=YES

alias g="git"
alias v='vim "$@"'
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
alias :gc='v ~/dotfiles/.gitconfig'
alias :d='cd ~/dotfiles'
alias :h='cd ~/homebrew'
alias :g='cd ~/repo/github.com'
#alias snip='open ~/.vim/bundle/snipMate/snippets'
a() { git add ${1:-.}; git status --short }
m() { git commit -m "$*" }

copy-line() { print -rn $BUFFER | pbcopy; zle -M "Copied: ${BUFFER}" }
zle -N copy-line
#bindkey '\@' copy-line

#zshプロンプトにモード表示####################################
PROMPT="%{$fg[red]%}[%{$reset_color%}%n%{$fg[red]%}]%#%{$reset_color%} "
if false; then
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
    PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[red]%}NOR%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
    ;;
    main|viins)
    PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
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
zstyle ":filter-select" case-insensitive yes
bindkey "^V" zaw-cdr
