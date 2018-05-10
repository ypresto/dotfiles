# Plugins

set FZF_LEGACY_KEYBINDINGS 0
set FZF_REVERSE_ISEARCH_OPTS -s
set FZF_FIND_AND_EXECUTE_OPTS -s

# Paths

set -x DOTFILES_PATH "$HOME/.homesick/repos/dotfiles"

set -x ANDROID_HOME "$HOME/.android-sdk"
set -x PATH $ANDROID_HOME/platform-tools $PATH

set -x PATH $HOME/.anyenv/bin $PATH
eval (anyenv init - --no-rehash fish | source)

eval (hub alias -s fish | source)

set -x PATH $HOME/bin $PATH

# Local config

if test -f "$HOME/fish_local_config.fish"
    source "$HOME/fish_local_config.fish"
end

# Completions

source "$HOME/.homesick/repos/homeshick/homeshick.fish"

# Commands

source "$DOTFILES_PATH/aliases.sh"

function a
    if [ -z "$argv" ]
        git add -A
    else
        git add $argv
    end
    git status --short
end

function cm
    git commit -m "$argv"
end

function submit
    set branch (git rev-parse --abbrev-ref HEAD)
    if [ "$branch" = "master" ]
        echo "Oops, current branch is master."
        return 1
    end
    git push $argv HEAD:$branch
end

function git-prune-branches-dry-run
    set branch $argv[1]; test -n "$branch"; or set branch master
    git fetch origin
    git fetch --dry-run --prune origin
    git branch --merged origin/$branch | grep -vE ' '$branch'$|^\*' | xargs echo git branch -d
end

function git-prune-branches
    set branch $argv[1]; test -n "$branch"; or set branch master
    git fetch --prune origin
    git branch --merged origin/$branch | grep -vE ' '$branch'$|^\*' | xargs git branch -d
end

function git-replace-branch
    set branch $argv[1]
    if test -z "$branch"
        echo 'New branch name is required.'
        return 1
    end
    set current (git rev-parse --abbrev-ref HEAD)
    git checkout -b $branch
    git branch -f $current origin/$current
end

# Confings

# https://github.com/fish-shell/fish-shell/issues/825#issuecomment-226646287
function sync_history --on-event fish_postexec
    history --save
    history --merge
end
