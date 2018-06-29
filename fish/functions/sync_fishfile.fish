function sync_fishfile
    set -q FISH_CONFIG_PATH; or return 1
    set -l from "$HOME/.config/fish/fishfile"
    set -l to (dirname_alt $FISH_CONFIG_PATH)/fishfile
    test -f $from; and cp -f $from $to
end
