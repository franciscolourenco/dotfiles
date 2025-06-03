#!/usr/bin/env bash
# Author: @franciscolourenco

echo


# ------------------------------- Links -------------------------------------
createLink () {
    rm -rf $2
    ln -s $1 $2
    linkResults="$linkResults\n $1 <-- $2@"
}

linkSafely () {
    if [ -e $2 ] && [ "`diff -rq $1 $2`" ]; then
        echo 'There is already a file at "'$2'" which is different from the one you are trying to install'.
        read -p  'Do you wish to overwrite? (y/n) '
        [ "$REPLY" == "y" ] && createLink $1 $2
        [ "$REPLY" != "y" ] && linkResults="$linkResults\n$2 X $1"
    else
        createLink $1 $2
    fi
}

repoDir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IFS=$'\n'
toReplace="home/"
for file in $(cd $repoDir && find home -type f \( ! -iname ".*" \)) ; do
    destination="${file/$toReplace/$HOME/.}"
    dirname=$(dirname $destination)
    basename=$(basename $destination)
    [ -d $dirname ] || mkdir -p "$dirname"
    linkSafely "$repoDir/$file" "$destination"
done

[ "$linkResults" ] && echo "Created symbolic links:"
echo -e "$linkResults" | sed s:"$HOME":"~":g | column -t && echo


# ------------------------------ rmate ------------------------------------
[ -n "$SSH_CLIENT" ] && ! hash rmate 2>/dev/null && {

    read -p "Do you want to install rmate to edit files remotely using Sublime Text?(y/n)"
    [ "$REPLY" == "y" ] && {
        echo "Installing rmate..."
        echo ""
        sudo wget -O /usr/local/bin/rmate https://raw.github.com/aurora/rmate/master/rmate
        sudo chmod a+x /usr/local/bin/rmate
    }
}

# ------------------------------- Git -------------------------------------
# hash git 2>/dev/null && {
#     read -p "Do you wish to configure git?(y/n) "
#     [ "$REPLY" == "y" ] && {
#         gitlocal="$HOME/.gitlocal"

#         # name
#         read -p "Name: "
#         [ "$REPLY" ] && git config -f "$gitlocal" user.name "$REPLY"
#         # email
#         read -p "Email: "
#         [ "$REPLY" ] && git config -f "$gitlocal" user.email "$REPLY"

#         if hash rmate 2>/dev/null; then
#             git config -f "$gitlocal" core.editor "rmate -w"
#         else
#             # make git wait for sublime text otherwise commit doesn't work
#             read -p "Do you want to edit commit messages using Sublime Text?(y/n)"
#             [ "$REPLY" == "y" ] && git config -f "$gitlocal" core.editor "subl -w -n --command toggle_side_bar"
#         fi
#         # use keychain to retrieve passwords on repositories cloned via https
#         [ "`uname`" == "Darwin" ] && git config -f "$gitlocal" credential.helper "osxkeychain"
#         echo
#         echo "Your preferences were saved in $gitlocal"
#         echo "This file may be used for configurations specific to this machine."
#         echo
#     }
# }


# ------------------------------- install/activate homebrew/fishfish ------------------------------------------

if [[ `uname` == "Darwin" ]]; then
    # Install homebrew
    if ! [ -x /opt/homebrew/bin/brew ]; then
        echo ""
        echo "Installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install fish shell
    if ! hash fish 2>/dev/null; then
        echo ""
        echo "Installing fish shell..."
        /opt/homebrew/bin/brew install fish
    fi

    # Install packages from Brewfile
    if [ -f "Brewfile" ]; then
        echo ""
        read -p "Would you like to install packages and apps from Brewfile? (y/n) " REPLY
        if [ "$REPLY" == "y" ]; then
            echo "Installing packages from Brewfile..."
            /opt/homebrew/bin/brew bundle
        fi
    fi

    # Add fish to shells
    if ! grep -q "/opt/homebrew/bin/fish" /etc/shells; then
            echo ""
            echo "Adding fish to shells..."
        sudo sh -c "echo /opt/homebrew/bin/fish >> /etc/shells"
    fi

    # Check if fish is already set as default shell
    if [ "$(dscl . -read /Users/$USER UserShell | awk '{print $2}')" != "/opt/homebrew/bin/fish" ]; then
        echo ""
        echo "Setting fish as default shell..."
        chsh -s /opt/homebrew/bin/fish
    fi

    # Install fisher and fisher plugins
    if ! [[ -f "$HOME/.config/fish/functions/fisher.fish" ]]; then
        echo ""
        echo "Installing fisher plugins..."
        /opt/homebrew/bin/fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"
    fi


    echo ""
    echo "Entering fish..."
    /opt/homebrew/bin/fish --login


else
    echo "To install fish shell visit: https://fishshell.com/"
fi

