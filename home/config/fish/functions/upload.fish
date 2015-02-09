function upload --description 'Upload a file to transfer.sh'
    # write url to tmpfile because of progress bar
    set tmpfile (mktemp -t transfer.XXX)
    curl --progress-bar --upload-file $argv https://transfer.sh/(basename $argv | tr -d [:space:]) >> $tmpfile
    cat $tmpfile
    # copy to clipboard if on OS X
    if type pbcopy > /dev/null
        pbcopy < $tmpfile
    end
    rm -f $tmpfile
end
