function reload
    reload_functions
    set -l status_fns $status
    reload_config
    set -l status_cfg $status
    return (math "1000 * $status_cfg + $status_fns")
end
