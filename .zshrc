autoload -U compinit promptinit colors
compinit # enable completion
promptinit # enable prompt
colors # enable colors

# prompt style
PROMPT="%~> "
RPROMPT="%n@%m"

# menu style, accept first sugestion, arrows selection
zstyle ':completion:*' menu yes select 
# colorful listings
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ''
# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
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
zstyle ':completion::complete:*' use-cache on
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
# Describe each match group.
zstyle ':completion:*:descriptions' format '%B%d%b'
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# kill completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# cd will never select the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*:cd:*' ignore-parents parent pwd


# options
setopt autocd
setopt NO_LIST_BEEP


# aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias ll="ls -l"
alias ..='cd ..'
alias .='pwd'
alias grep='grep -E --color=always'
alias dir='ls -1'
alias c="clear"

if ls -F --color=auto >&/dev/null; then
  alias ls="ls --color=auto -F"
else
  alias ls="ls -F"
fi


#copy with progress bar
alias cp='rsync -aP'
alias netstat='netstat -ap'

#bash style ctrl-a (beginning of line) and ctrl-e (end of line)
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line