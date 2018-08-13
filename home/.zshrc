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
alias dcn='env PRODUCT_WORK_DIR=(git rev-parse --show-toplevel) docker-compose -f docker-compose.yml -f docker-compose-nfs.yml '
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

ranking () {
    history 1 | awk '{print $2}' | sort | uniq -c | sort -nr | head -n30
}

# Misc.

if [ -f "$HOME/.zshrc_local" ]; then
    source $HOME/.zshrc_local
fi

typeset -U path
