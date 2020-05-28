#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

# Envs

HOMEBREW_PATH="/usr/local"
export DOTFILES_PATH="$HOME/.homesick/repos/dotfiles"
export CLICOLOR=1

# Paths (Also see .zshenv)

path=(
    $HOME/bin
    $DOTFILES_PATH/bin
    $path
)

source "$HOME/.homesick/repos/homeshick/homeshick.sh"

command -v direnv > /dev/null && eval "$(direnv hook zsh)"

# Plugins

ZPLUG_HOME=~/.zplug
source $ZPLUG_HOME/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2

# pure
zplug 'mafredri/zsh-async', from:github
zplug 'sindresorhus/pure', use:pure.zsh, from:github, as:theme

## enhancd
# requires fzf
ENHANCD_COMMAND=ecd
zplug 'b4b4r07/enhancd', use:init.sh
__enhancd_ctrl_v() {
    __enhancd::cd -
    zle reset-prompt
}
zle -N __enhancd_ctrl_v
bindkey '^V' __enhancd_ctrl_v
# https://github.com/b4b4r07/enhancd/issues/63
autoload -Uz add-zsh-hook
add-zsh-hook chpwd __enhancd::cd::after

# fzf
# NOTE: binary is not included.
zplug 'junegunn/fzf', use:'shell/key-bindings.zsh', from:github
export FZF_DEFAULT_OPTS='--height 20% --layout=reverse --inline-info'
# https://github.com/junegunn/fzf/wiki/Color-schemes#one-dark without bg+
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:-1,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
'
export FZF_CTRL_R_OPTS='--with-nth=2..'

# TODO
# zplug 'junegunn/fzf', use:'shell/*.zsh', from:github, hook-load:__zshrc_init_fzf__
# export FZF_COMPLETION_TRIGGER=''
# __zshrc_init_fzf__() {
#     bindkey '^T' fzf-completion
#     bindkey '^I' $fzf_default_completion
# }

__ypresto_git_fzf() {
    file=`git ls-files | fzf`
    [ $! -ne 0 ] && return
    BUFFER="${BUFFER}$file"
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N __ypresto_git_fzf
bindkey '^G' __ypresto_git_fzf

## completions
fpath=($fpath ~/.zsh/functions)
zplug 'zsh-users/zsh-completions'
zplug 'docker/cli', use:'contrib/completion/zsh'
zplug 'docker/compose', use:'contrib/completion/zsh'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# Configs

bindkey -e

setopt auto_cd
setopt auto_pushd
setopt interactive_comments

# Make Ctrl+Q work.
unsetopt flow_control
stty start undef
stty stop undef


WORDCHARS="${WORDCHARS//\/}"

# History

setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Aliases

if which hub > /dev/null; then
    eval "$(hub alias -s zsh)"
fi

source "$DOTFILES_PATH/aliases.sh"

# Custom functions

a() { 1=${1:--A}; git add $*; git status --short }

cm() { git commit -m "$*" }
cmn() { git commit --no-verify -m "$*" }

submit() {
    local remote=$1
    shift 1
    local branch=`git rev-parse --abbrev-ref HEAD`
    if [ "$branch" = "master" ]; then
      print "Oops, current branch is master."
      return 1
    fi
    git push "$@" $remote HEAD:$branch
}

git-prune-branches-dry-run() {
    branch=${1:-master}
    git fetch --dry-run --prune origin
    git fetch origin && git branch --merged origin/$branch | grep -vE ' '$branch'$|^\*' | xargs echo git branch -d
}

git-prune-branches() {
    branch=${1:-master}
    git fetch --prune origin && git branch --merged origin/$branch | grep -vE ' '$branch'$|^\*' | xargs git branch -d
}

git-replace-branch() {
    branch=${1}
    if [ -z "$branch" ]; then
        echo 'New branch name is required.'
        return 1
    fi
    current=`git rev-parse --abbrev-ref HEAD`
    git checkout -b $branch
    git branch -f $current origin/$current
}

ranking () {
    history 1 | awk '{print $2}' | sort | uniq -c | sort -nr | head -n30
}

dc() {
  # https://stackoverflow.com/questions/7359204/git-command-line-know-if-in-submodule#comment73689214_7359204
  local toplevel=$(git rev-parse --show-superproject-working-tree --show-toplevel 2> /dev/null | head -1)

  (
    chpwd_functions= cd "${toplevel}" &&
    PRODUCT_WORK_DIR="${toplevel}" docker-compose "$@"
  )
}
compdef dc='docker-compose'

alias dcn="dc -f docker-compose.yml -f docker-compose-nfs.yml"
alias dcd="dc -f docker-compose.yml -f docker-compose-dev.yml"
alias dcm="dc -f docker-compose.yml -f docker-compose-mutagen.yml"

random-str() {
  cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-24} | head -n 1
}

# Custom keybindings

expand-all-aliases() {
  local new_buffer=()
  for word in ${=BUFFER}; do
    new_buffer=($new_buffer ${aliases[$word]:-$word})
  done
  BUFFER=${(j: :)new_buffer}
  zle end-of-line
}
zle -N expand-all-aliases
bindkey '\e^E' expand-all-aliases

bindkey "^[u" undo
bindkey "^[r" redo

# Misc.

if [ -f "$HOME/.zshrc_local" ]; then
    source $HOME/.zshrc_local
fi

typeset -U path
