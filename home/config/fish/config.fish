if status --is-login

    # complete path
    set -x PATH /usr/local/bin /usr/local/sbin $PATH .

    # add personal binaries to path
    if [ -d $HOME/Dropbox/bin ]
        set -x PATH $PATH "$HOME/Dropbox/bin"
    end

end

if status --is-interactive

    # set e to sublime if available, otherwise use nano
    if [ -f '/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl' ]
        set -x PATH $PATH /Applications/Sublime Text 2.app/Contents/SharedSupport/bin
        alias e "subl -n"
    else
        alias e "nano"
    end

    # set launchbar alias if launchbar is installed
    if [ -e '/Applications/Launchbar.app' ]
        alias launchbar "open -a launchbar"
    end

    # improve ls colors
    set -x LSCOLORS dxfxcxdxbxegedabagacad

    # ----- git aliases -----
    alias g "git"
    alias s "git status"
    alias c "git commit"
    alias d "git diff"
    alias b "git branch"
    alias commit "git commit"
    alias changes "git diff"
    alias branch "git branch"
    alias add "git add"
    alias checkout "git checkout"
    alias log "git log"
    alias lg "git lg"
    alias merge "git merge"
    alias pull "git pull"
    alias push "git push"
    alias rebase "git rebase"
    alias reset "git reset"
    alias show "git show"
    alias tag "git tag"
    alias remove "git rm"
    alias move "git mv"
    alias stash "git stash"
    alias clone "git clone"
    alias remote "git remote"

end
