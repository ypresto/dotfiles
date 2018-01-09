# Plugins

set -U FZF_LEGACY_KEYBINDINGS 0

# Paths

set -x DOTFILES_PATH "$HOME/.homesick/repos/dotfiles"

set -x PATH $HOME/.anyenv/bin $PATH
eval (anyenv init - fish | source)

eval (hub alias -s fish | source)

# Completions

source "$HOME/.homesick/repos/homeshick/homeshick.fish"

# Aliases

source "$DOTFILES_PATH/aliases.sh"

function a
    if [ -z $argv ]
        git add -A
    else
        echo test
        git add $argv
    end
    git status --short
end

function cm
    git commit -m "$argv"
end

function submit
    set remote $argv[0]
    local branch=`git rev-parse --abbrev-ref HEAD`
    if [ "$branch" = "master" ]
        print "Oops, current branch is master."
        return 1
    end
    git push $argv[1..-1] $remote HEAD:$branch
end

# Confings

# https://github.com/fish-shell/fish-shell/issues/825#issuecomment-226646287
function sync_history --on-event fish_preexec
    history --save
    history --merge
end
