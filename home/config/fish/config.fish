# homebrew
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
    fish_add_path -g "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" # coreutils gnubin
end

fish_add_path -g "$HOME/.local/bin" # user binaries and uv tools
fish_add_path -g "$HOME/.cargo/bin" # cargo binaries
fish_add_path -g "$HOME/go/bin" # go user path
fish_add_path -g "/Applications/Postgres.app/Contents/Versions/latest/bin" # postgres.app if installed

# set editor to Sublime if available, otherwise use rmate, nano
if test -f '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'
    fish_add_path -g "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
    set -x EDITOR "subl --new-window"
    set -x KUBE_EDITOR "subl --wait --new-window --command toggle_side_bar"
else if type -q rmate
    set -x EDITOR rmate
else
    set -x EDITOR nano
end

# local config
if test -f ~/.config/fish/config-local.fish
    source ~/.config/fish/config-local.fish
end

if status --is-interactive
    # color commands params and strings
    set -g fish_color_command green
    set -g fish_color_param normal
    set -g fish_color_quote E6E364

    # set tab width to 4 spaces instead of 8
    tabs -4

    # use new key bindings of fzf
    set -x FZF_LEGACY_KEYBINDINGS 0

    # configure less to use 4 spaces for tabs
    set -x LESS "-RF --tabs=4 --quit-if-one-screen --mouse"

    # rbenv
    if type -q rbenv
        rbenv init - | source -
    end

    # starship prompt
    if type -q starship
        starship init fish | source
    end
end
