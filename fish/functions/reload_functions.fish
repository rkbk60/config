function reload_functions
    set -g ___TMP_STATUS 0
    set -l config_dir (string replace '/config.fish' '/functions' $FISH_CONFIG_PATH)
    find $config_dir/*.fish -maxdepth 0 \
        | string replace -ar '^.*/([^/]*)\.fish.*$' \
            'ln -sf @1$1.fish @2$1.fish; and source @2$1.fish; or set -g ___TMP_STATUS (math "1 + $$___TMP_STATUS")' \
        | string replace -a  '@1' $config_dir/ \
        | string replace -a  '@2' '~/.config/fish/functions/' \
        | source
    set -l function_status (math "$___TMP_STATUS + $status")
    set -e ___TMP_STATUS
    return $function_status
end
