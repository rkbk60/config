function __current_git_branch_name
    success git log -1
        and echo -n (git branch ^ /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
end
