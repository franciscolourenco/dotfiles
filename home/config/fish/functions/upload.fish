function upload --description 'Upload a file to transfer.sh'

        set tmpfile (mktemp -t transfer.XXXXX)
        curl --progress-bar --upload-file $argv https://transfer.sh/(basename $argv) >> $tmpfile
        cat $tmpfile
        pbcopy < $tmpfile
        rm -f $tmpfile

end
