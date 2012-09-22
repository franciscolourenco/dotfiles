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
        function e
            if [ $argv ]
                'subl' -n $argv
            else
                'subl' .
            end
        end
    else
        function e
            if [ $argv ]
                nano -n $argv
            else
                nano .
            end
        end
    end

end