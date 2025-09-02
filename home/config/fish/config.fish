fish_add_path -g . # current folder
fish_add_path -g /opt/homebrew/bin/ # homebrew
fish_add_path -g "$HOME/.local/bin" # user binaries
fish_add_path -g "$HOME/.cargo/bin" # cargo binaries
fish_add_path -g "/Applications/Postgres.app/Contents/Versions/latest/bin" # postgres.app if installed
fish_add_path -g /usr/local/opt/coreutils/libexec/gnubin # coreutils gnubin

# go user path
set -Ux fish_user_paths /Users/user/go/bin $fish_user_paths

# local config
if test -f ~/.config/fish/config-local.fish
    source ~/.config/fish/config-local.fish
end

if status is-login
    # orbstack
    source ~/.orbstack/shell/init2.fish 2>/dev/null || : # orbstack

    # set e to sublime if available, otherwise use rmate, nano
    if test -f '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'
        fish_add_path -g /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
        set -x EDITOR "subl --new-window"
        set -x KUBE_EDITOR "subl --wait --new-window --command toggle_side_bar"
    else if type -q rmate
        set -x EDITOR rmate
    else
        set -x EDITOR nano
    end

    # improve ls colors on osx / bsd
    set -x LSCOLORS exfxbxdxcxegedxbxgxcac

    #colors
    set -x fish_color_command green
    set -x fish_color_param normal
    set -x fish_color_quote E6E364

    # rbenv
    if type -q rbenv
        rbenv init - | source -
    end

    # use new key bindings of fzf
    set -x FZF_LEGACY_KEYBINDINGS 0

    # set launchbar alias if launchbar is installed
    if test -e '/Applications/Launchbar.app'
        alias launchbar "open -a launchbar"
    end

    # set tab width to 3 spaces instead of 8
    tabs -3

    # pnpm
    set -x PNPM_HOME /Users/user/Library/pnpm
    fish_add_path -g "$PNPM_HOME"

    # configure pipenv to create virtualenvs in the project folder
    set -x PIPENV_VENV_IN_PROJECT 1

    # disable virtualenv's default prompt
    set -x VIRTUAL_ENV_DISABLE_PROMPT 1

    # configure less to use 4 spaces for tabs
    set -x LESS "-RF --tabs=4 --quit-if-one-screen --mouse"
end

if status is-interactive
    # function and aliases need to be set in every shell, because they cannot be exported at login

    alias e $EDITOR

    #pyenv
    if type -q pyenv
        set -x PYENV_ROOT $HOME/.pyenv
        fish_add_path -g $PYENV_ROOT/bin
        pyenv init - | source
    end

    # python virtualenv auto load when changing directory.
    # note: this assumes a virtualenv was created and stored in the project directory with: `virtualenv .venv`
    function auto_virtualenv --on-variable PWD
        if test -d ".venv"
            if not set -q VIRTUAL_ENV
                set --export --global venv_root $PWD
                source .venv/bin/activate.fish
            end
        else
            if set -q VIRTUAL_ENV
                if set -q venv_root
                    if not string match --entire --quiet $venv_root $PWD
                        set --erase venv_root
                        deactivate
                    end
                end
            end
        end
    end

    # in case the shell is started in a directory which contains a virtualenv
    auto_virtualenv

end

# starship prompt
starship init fish | source
