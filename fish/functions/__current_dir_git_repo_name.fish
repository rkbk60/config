function __current_dir_git_repo_name
    success git rev-parse
        and echo -n (basename (git rev-parse --show-toplevel))
end
