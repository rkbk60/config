function __dotfiles_path
    string replace -r '/fish/config.fish$' '' $FISH_CONFIG_PATH
end
