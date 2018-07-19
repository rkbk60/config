function error
    set -q argv; and echo "$argv" > /dev/stderr
    return 1
end
