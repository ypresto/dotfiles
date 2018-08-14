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

# Plugins

ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2

# pure
zplug 'mafredri/zsh-async', from:github
zplug 'sindresorhus/pure', use:pure.zsh, from:github, as:theme

## enhancd
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

# zsh-fzy
zplug 'aperezdc/zsh-fzy'
bindkey '^R'  fzy-history-widget

## completions
zplug 'zsh-users/zsh-completions'
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

source "$DOTFILES_PATH/aliases.sh"
alias dcn='PRODUCT_WORK_DIR=$(git rev-parse --show-toplevel) docker-compose -f docker-compose.yml -f docker-compose-nfs.yml'
alias git-new-workdir="$HOMEBREW_PATH/share/git-core/contrib/workdir/git-new-workdir"
alias ws='python -m SimpleHTTPServer'

# Custom functions

a() { 1=${1:--A}; git add $*; git status --short }

cm() { git commit -m "$*" }

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

# Misc.

if [ -f "$HOME/.zshrc_local" ]; then
    source $HOME/.zshrc_local
fi

typeset -U path
