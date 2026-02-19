#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

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

# Envs

export DOTFILES_PATH="$HOME/.homesick/repos/dotfiles"
export CLICOLOR=1
export EDITOR='vim'
export LESS='-RSiM'
export AWS_VAULT_KEYCHAIN_NAME='login'

# Paths (Also see .zshenv)

path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$DOTFILES_PATH/bin"
  $path
)

if type go &>/dev/null; then
  path+="$(go env GOPATH)/bin"
fi


source "$HOME/.homesick/repos/homeshick/homeshick.sh"

command -v direnv > /dev/null && eval "$(direnv hook zsh)"

# Plugins

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# pure
zinit ice pick'async.zsh' src'pure.zsh'
zinit light 'sindresorhus/pure'

## enhancd
# requires fzf
ENHANCD_COMMAND=ecd
zinit ice pick:'init.sh'
zinit light 'b4b4r07/enhancd'
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
zinit ice pick:'shell/key-bindings.zsh'
zinit light 'junegunn/fzf'
export FZF_DEFAULT_OPTS='--height 20% --layout=reverse --inline-info'
# https://github.com/junegunn/fzf/wiki/Color-schemes#one-dark without bg+
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:-1,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
'
export FZF_CTRL_R_OPTS='--with-nth=2..'

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

# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
    zinit add-fpath --front "$HOMEBREW_PATH/share/zsh/site-functions"
fi

autoload compinit && compinit
autoload bashcompinit && bashcompinit

if type terraform &>/dev/null; then
    complete -o nospace -C "$HOMEBREW_PATH/bin/terraform" terraform
fi

zinit for light-mode as"null" atclone:'npm i' atpull'%atclone' atload:'complete -C `pwd`/tsc-completion.js tsc' 'minestarks/tsc-completion'

zinit light 'zdharma/fast-syntax-highlighting'
zinit light 'zsh-users/zsh-autosuggestions'

zinit ice atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
zinit light g-plane/pnpm-shell-completion

if type docker &>/dev/null; then
    source <(docker completion zsh)
fi

if type kubectl &>/dev/null; then
    source <(kubectl completion zsh)
fi

# Aliases

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

compdef dc='docker compose'

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

# Aqua

# Append personal aqua config (company config takes precedence)
export AQUA_GLOBAL_CONFIG="${AQUA_GLOBAL_CONFIG:+${AQUA_GLOBAL_CONFIG}:}${HOME}/.config/aquaproj-aqua/personal.yaml"

export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"

# Bun

# bun completions
[ -s "/Users/yuya.tanaka.001/.bun/_bun" ] && source "/Users/yuya.tanaka.001/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Misc.

if [ -f "$HOME/.zshrc_local" ]; then
    source $HOME/.zshrc_local
fi

typeset -U path

echo 'Call "zinit self-update" and "zinit update --all" once in a while. brew upgrade also necessary for zsh, fzf and etc.'
