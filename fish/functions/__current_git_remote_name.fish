function __current_git_remote_name
    success git rev-parse
        and echo -n (git remote show ^ /dev/null)
end
