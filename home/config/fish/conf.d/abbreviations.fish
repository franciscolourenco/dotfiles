function abbreviations --on-event fish_prompt
    # ----- git aliases -----
    abbr --add --global s "git status"
    abbr --add --global b "git branch"
    abbr --add --global c "git commit"
    abbr --add --global commit "git commit"
    abbr --add --global changes "git diff"
    abbr --add --global branch "git branch"
    abbr --add --global add "git add"
    abbr --add --global checkout "git checkout"
    abbr --add --global log "git log"
    abbr --add --global lg "git lg"
    abbr --add --global lgmerge "git lgmerge"
    abbr --add --global lgmine "git lgmine"
    abbr --add --global merge "git merge"
    abbr --add --global pull "git pull"
    abbr --add --global push "git push"
    abbr --add --global force "git push --force-with-lease"
    abbr --add --global rebase "git rebase --ignore-date"
    abbr --add --global reset "git reset"
    abbr --add --global hard "git reset --hard"
    abbr --add --global clean "git clean -dff"
    abbr --add --global show "git show"
    abbr --add --global tag "git tag"
    abbr --add --global remove "git rm"
    abbr --add --global move "git mv"
    abbr --add --global stash "git stash"
    abbr --add --global clone "git clone"
    abbr --add --global remote "git remote"
    abbr --add --global revert "git revert"
    abbr --add --global fetch "git fetch"
    abbr --add --global amend "git commit --amend"
    abbr --add --global pick "git cherry-pick"
    abbr --add --global cherry "git cherry-pick"
    abbr --add --global check git "checkout (git reflog | egrep -io \"moving from ([^[:space:]]+)\" | awk '{ print \$3 }' | awk ' !x[\$0]++' | egrep -v '^[a-f0-9]{40}\$' | fzf | xargs)"

    abbr --add --global ll "ls -Alrth"
    abbr --add --global mkdirs "mkdir -p" # make intermediary directories
    abbr --add --global k kubectl
    abbr --add --global pubkey "cat ~/.ssh/id_rsa.pub | pbcopy"
    abbr --add --global ports "lsof -PiTCP -sTCP:LISTEN"
    abbr --add --global review "git reset (git merge-base head staging)"
    abbr --add --global beblg "git lg --grep='^v[0-9]\+\.[0-9]\+\.[0-9]\+' --grep='Merge pull request .\+beb-'"
    abbr --add --global !! "gh copilot suggest"


    # delete itself so it is only executed once per session
    functions --erase abbreviations
end
