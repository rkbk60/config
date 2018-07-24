function __dotfiles_completion
    set -qg __dotfiles_virtual_pwd
        or set -g __dotfiles_virtual_pwd (__dotfiles_path)
    ls --color=never $__dotfiles_virtual_pwd | string replace -r '$' '/'
end
