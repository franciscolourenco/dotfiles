umask 027

if status --is-login

    # complete path
    set -x PATH /usr/local/bin /usr/local/sbin $PATH .

    # add personal binaries to path
    if [ -d $HOME/Dropbox/bin ]
        set -x PATH $PATH "$HOME/Dropbox/bin"
    end

    # add coreutils gnubin if installed
    if type brew >/dev/null 2>&1
        set gnubin (brew --prefix coreutils)/libexec/gnubin
        if [ -d $gnubin ]
            set -x PATH $gnubin $PATH
        end
        # add npm binaries from homebrew to path if installed
        if [ -d '/usr/local/share/npm/bin' ]
            set -x PATH '/usr/local/share/npm/bin' $PATH
        end
    end

end

if status --is-interactive

    # set e to sublime if available, otherwise use nano
    if [ -f '/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl' ]
        set -x PATH $PATH /Applications/Sublime Text 2.app/Contents/SharedSupport/bin
        set -x EDITOR "subl -n"
    else
        set -x EDITOR "nano"
    end
    alias e $EDITOR

    # set launchbar alias if launchbar is installed
    if [ -e '/Applications/Launchbar.app' ]
        alias launchbar "open -a launchbar"
    end

    # improve ls colors
    set -x LSCOLORS dxfxcxdxbxegedabagacad

    # make intermediary directories
    alias mkdirs "mkdir -p"

    #virtualenvwrapper
    if [ -f ~/.config/fish/virtualfish/virtual.fish ]
        . ~/.config/fish/virtualfish/virtual.fish
    end


    set -x WORKON_HOME "~/.virtualenv"

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
    alias revert "git revert"
    alias fetch "git fetch"

end
