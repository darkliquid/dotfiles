function gochk --description 'Check and lint go code'
    if test "$argv" -eq ""
        set argv .
    end
    
    gofmt -l $argv
    if test $status -ne 0
        echo "gofmt: your code requires gofmt-ing"
    end
    
    gometalinter --disable=gotype --disable=errcheck $argv
end
