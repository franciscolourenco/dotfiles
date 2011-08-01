autoload -U compinit promptinit colors zmv
compinit # enable completion
promptinit # enable prompt
colors # enable colors

# prompt style
PROMPT="%~> "
RPROMPT="%n@%m"


#{{{ Completion Stuff

# menu style, accept first sugestion, arrows selection
zstyle ':completion:*' menu yes select 
# colorful listings
zmodload -i zsh/complist


# competer order
zstyle ':completion:*' completer _complete _match _correct _approximate _history _prefix
# _expand: to me used before completer
# _complete: the standard completer
# _match: support wildcards (use after _complete)
# _correct: calls _approximate but only selects only correct suggestions
# _approximate: allows errors

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes' T
# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
# Separate matches into groups
zstyle ':completion:*' group-name ''
# Order of groups on command completion
zstyle ':completion:*:*:-command-:*' group-order local-directories builtins commands parameters
# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"
# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
#history stuff
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
# kill completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
# cd will never select the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Separate man page sections.  Neat.
zstyle ':completion:*:manuals' separate-sections true


#formating
zstyle ':completion:*:descriptions' format "%B====== %d ======%b"
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%F{9}---- no match for: %d%f%b'
zstyle ':completion:*:corrections' format '%B---- %d %F{11}(errors: %e)%f%b'

#}}}

#{{{ Options

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD
# Spell check commands!  (Sometimes annoying)
setopt CORRECT
# This makes cd=pushd
setopt AUTO_PUSHD
# No more annoying pushd messages...
setopt PUSHD_SILENT
# blank pushd goes to home
setopt PUSHD_TO_HOME
# this will ignore multiple directories for the stack.  Useful?  I dunno.
setopt PUSHD_IGNORE_DUPS
# If we have a glob this will expand it
setopt GLOB_COMPLETE
setopt PUSHD_MINUS
# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
setopt RM_STAR_WAIT
# use magic (this is default, but it can't hurt!)
setopt ZLE
# beeps are annoying
setopt NO_LIST_BEEP
# Keep echo "station" > station from clobbering station
setopt NO_CLOBBER
# Case insensitive globbing
setopt NO_CASE_GLOB
# Be Reasonable!
setopt NUMERIC_GLOB_SORT
# I don't know why I never set this before.
setopt EXTENDED_GLOB
# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
setopt RC_EXPAND_PARAM

#}}}


#{{{ aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias ls='ls -GFl1'
alias ll="ls -l"
alias la="ls -a"
alias ..='cd ..'
alias - -=cd\ -
alias grep='grep -E --color=always'
alias c="clear"
alias launchbar="open -a launchbar"
alias pd="popd"
alias rz='source ~/.zshrc'
alias ez='subl ~/.zshrc'
alias netstat='netstat -ap'

#copy with progress bar
#alias cp='rsync -aP'

#}}}

#{{{ History Stuff
# Where it gets saved
HISTFILE=~/.history
# Remember about a years worth of history (AWESOME)
SAVEHIST=10000
HISTSIZE=10000
# Don't overwrite, append!
setopt APPEND_HISTORY
# Killer: share history between multiple shells
setopt SHARE_HISTORY
# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS
# Even if there are commands inbetween commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS
# Pretty    Obvious.  Right?
setopt HIST_REDUCE_BLANKS
# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY
# Save the time and how long a command ran
setopt EXTENDED_HISTORY

setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
#}}}

#bash style ctrl-a (beginning of line) and ctrl-e (end of line)
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

#make return key accept autocompletion and send command
bindkey -M menuselect '^M' .accept-line

export LSCOLORS=dxfxcxdxbxegedabagacad
export EDITOR='subl -w'
export PATH="/usr/local/bin:/usr/local/sbin:$PATH:/Developer/usr/bin:/Users/user/.bin"

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
. $HOME/.venvburrito/startup.sh # startup virtualenv-burrito
