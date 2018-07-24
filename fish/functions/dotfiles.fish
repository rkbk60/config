function dotfiles
    if set -qg FISH_CONFIG_PATH
        set -l path (__dotfiles_path)
        test -d "$path/$argv"
            and cd "$path/$argv"
            or  cd "$path/$argv"
    else
        echo "Error: Missing FISH_CONFIG_PATH" >/dev/stderr
        return 1
    end
end
