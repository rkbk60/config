function dirname_alt -a arg
    test -d $arg
        and echo $arg
        or  string replace -r '/[^/]*$' '/' $arg
end
