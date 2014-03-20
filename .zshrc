#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

if [ -f "$HOME/.zshrc_local_init" ]; then
    source "$HOME/.zshrc_local_init"
fi

if [ "$TERM" = "xterm" ]; then
    # No it isn't, it's gnome-terminal
    export TERM=xterm-256color
fi

export LANG

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

setopt INTERACTIVE_COMMENTS


autoload -U +X bashcompinit && bashcompinit
source "$HOME/dotfiles/bashcomp/tig-completion.bash"

# source ~/.bashrc

_missing_commands=''
function _is_available () {
    which $1 >/dev/null 2>&1 && return 0 || return 1
}
function _should_available () {
    if _is_available $1; then
        return 0
    else
        _not_available $1
        return 1
    fi
}
function _not_available () {
    _missing_commands="$_missing_commands $1"
}

# *** moved from .bashrc_public ***

if _is_available 'gls'; then
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

if _is_available 'gfind'; then
    alias find='gfind'
fi

# color / ignore case
alias less='less -Ri'
if _should_available 'lv'; then
    export PAGER='lv -c'
else
    export PAGER='less -Ri'
fi
export PAGER='less -Ri'

# ENV
export PATH="$HOME/dotfiles/bin:$HOME/dotfiles/node_modules/.bin:$HOME/node_modules/.bin:$PATH"
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
PROMPT2="%{$reset_color%}%{${fg[blue]}%}%_> %{${reset_color}%}"
SPROMPT="%{$reset_color%}%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
VCS_PROMPT="%{$reset_color%}%1(v|%F{green} %1v%f|)"
DIR_PROMPT="%{$reset_color%}%{${fg[blue]}%}[%~]%{${reset_color}%}"
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
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

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
alias V='gvi "$@"'
alias d='git diff'
alias D='git diff --color-words'
alias c='git diff --cached'
alias C='git diff --cached --color-words'
alias s='git status --short --branch'
alias t='tig'
alias p='popd'
alias gl='g l'
alias gg='g g'
alias :q='exit'
alias :z='v ~/dotfiles/.zshrc'
alias :zl='v ~/.zshrc_local'
alias :zz='. ~/.zshrc'
alias :b='v ~/.bashrc'
alias :bb='. ~/.bashrc'
alias :v='v ~/dotfiles/.vimrc'
alias :V='V ~/dotfiles/.vimrc'
alias :gc='v ~/dotfiles/.gitconfig'
alias :gcl='v ~/.gitconfig_local'
alias :d='cd ~/dotfiles'
alias :t='v ~/dotfiles/.tigrc'
alias :h=' \
    [ -d ~/homebrew ] && cd ~/homebrew || \
    [ -d /usr/local ] && cd /usr/local || \
    echo "no homebrew" >&2 && return 1'
alias :g='cd ~/repo/github.com'
alias :by='v ~/dotfiles/byobu_keybindings'
#alias snip='open ~/.vim/bundle/snipMate/snippets'
a() { 1=${1:--A}; git add $*; git status --short }
m() { git commit -m "$*" }
submit() {
    local remote=$1
    shift 1
    local branch=`git rev-parse --abbrev-ref HEAD`
    git push "$@" $remote HEAD:$branch
}
submit-to() {
    local remote=$1
    local branch=$2
    shift 2
    git push "$@" $remote HEAD:$branch
}
checkin() { git push gerrit HEAD:refs/for/$1 }

copy-line() { print -rn $BUFFER | pbcopy; zle -M "Copied: ${BUFFER}" }
zle -N copy-line
#bindkey '\@' copy-line

#zshプロンプトにモード表示####################################
# PROMPT="%{$fg[red]%}[%{$reset_color%}%n%{$fg[red]%}]%#%{$reset_color%} " # username pattern
PROMPT="%{$reset_color%}%{$CONFIG_PROMPT_COLOR%}[%{$reset_color%}${HOST%%.*}%{$CONFIG_PROMPT_COLOR%}]%#%{$reset_color%} " # hostname pattern
if false; then
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
    PROMPT="%{$reset_color%}%{$CONFIG_PROMPT_COLOR%}[%{$reset_color%}%n/%{$fg_bold[red]%}NOR%{$reset_color%}%{$CONFIG_PROMPT_COLOR%}]%#%{$reset_color%} "
    ;;
    main|viins)
    PROMPT="%{$reset_color%}%{$CONFIG_PROMPT_COLOR%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$CONFIG_PROMPT_COLOR%}]%#%{$reset_color%} "
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
bindkey '^Z^D' zaw-cdr
bindkey '^V' zaw-cdr
bindkey '^Z^G' zaw-git-files
bindkey '^O' popd
bindkey '^Z^B' zaw-git-recent-branches

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

if _should_available 'hub'; then
    eval "$(hub alias -s zsh)"
fi
# hack to activate hub completions
_hub >/dev/null 2>&1

# for ubuntu
if _is_available 'ack-grep'; then
    alias ack='ack-grep'
    # compdef ack-grep=ack
fi

alias gvimcd="gvim -c 'cd \`pwd\`'"

if [ "`uname`" = "Darwin" ]; then
    alias gvim=mvim
    alias gvimdiff=mvimdiff
fi

# Refer: http://d.hatena.ne.jp/namutaka/20100118/1263830555
# .zshrc
# command "mvi"
function gvi() {
    if [ $# != 0 ]; then
        gvim --remote-tab-silent $@ 2> /dev/null
    else
        srvs=`gvim --serverlist 2> /dev/null`
        if [ "$srvs" != "" ]; then
            gvim --remote-send "<Esc>:tabnew<CR>"
        else
            gvim
        fi
    fi
}

cl () { cd $1; ls }
mkcd () { mkdir -p $1; cd $1 }

# completion colors
# http://linuxshellaccount.blogspot.jp/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

if [ "$BYOBU_BACKEND" = "tmux" ]; then
    # work arround for automatic-rename local option is set by someone
    tmux set-window-option -u automatic-rename
fi

# bleeding edge
if [ -e "$HOME/homebrew/share/git-core/contrib/workdir/git-new-workdir" ]; then
    alias git-new-workdir="sh $HOME/homebrew/share/git-core/contrib/workdir/git-new-workdir"
elif [ -e "/usr/share/doc/git-1.7.10.2/contrib/workdir/git-new-workdir" ]; then
    alias git-new-workdir="sh /usr/share/doc/git-1.7.10.2/contrib/workdir/git-new-workdir"
else
    _not_available 'git-new-workdir'
fi
alias :vl='vim ~/.vimlocal/.vimrc'
if [ "`uname`" = "Darwin" ]; then
    alias fixfont="defaults -currentHost write -globalDomain AppleFontSmoothing -int 2"
fi
# export PERL5LIB="./lib:./t/inc:$PERL5LIB"
alias ws='python -m SimpleHTTPServer'

wsr() {
ruby -rwebrick <<EOS
    server = WEBrick::HTTPServer.new(:Port => $hoge, :DocumentRoot => Dir.pwd)
    trap 'INT' do server.shutdown end
    server.start
EOS
}

unalias ag 2> /dev/null
orig_ag=`which ag`
alias agnb="$orig_ag --pager='less -RS'"
alias ag="$orig_ag --search-binary --pager='less -RS'"

alias modified='git diff --name-only'
alias staged='git diff --name-only --cached'

if [ -f "$HOME/.zshrc_local" ]; then
    source $HOME/.zshrc_local
fi

ranking () {
    history 1 | awk '{print $2}' | sort | uniq -c | sort -nr | head -n30
}


[ -n "$_missing_commands" ] && echo "Command not available:$_missing_commands"

function _is_available () {
    which $1 >/dev/null 2>&1 && return 0 || return 1
}
function _should_available () {
    if _is_available $1; then
        return 0
    else
        _not_available $1
        return 1
    fi
}
function _not_available () {
    _missing_commands="$_missing_commands $1"
}

unfunction _is_available _should_available _not_available
unset _missing_commands
