function __current_dir_git_info
    if success git rev-parse
        __set_git_state_color
        echo -n (git branch ^ /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
        set_color normal -b normal
    end
end
