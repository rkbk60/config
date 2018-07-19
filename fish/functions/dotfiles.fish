function dotfiles
    if set -qg FISH_CONFIG_PATH
        cd (string replace -r '/fish/config.fish$' '' $FISH_CONFIG_PATH)
    else
        echo "Error: Missing FISH_CONFIG_PATH" >/dev/stderr
        return 1
    end
end
