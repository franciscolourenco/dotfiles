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
    end

    # add postgres.app to path if installed
    if [ -d /Applications/Postgres.app/Contents/MacOS/bin ]
        set -x PATH $PATH "/Applications/Postgres.app/Contents/MacOS/bin"
    end
end

if status --is-interactive

    # set e to sublime if available, otherwise use nano
    if [ -f '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' ]
        set -x PATH $PATH /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
        set -x EDITOR "subl"
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
        . ~/.config/fish/virtualfish/auto_activation.fish
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

    # ----- other aliases -----
    alias ll "ls -Alrth"

    #colors
    set -x fish_color_user F92672
    set -x fish_color_host FD971F
    set -x fish_color_cwd A6E22E

    # set tab width to 3 spaces instead of 8
    tabs -3

end
