function fish_prompt
    set -l last_status $status
    echo

    if not test (builtin pwd) = $HOME
        if success git rev-parse
            __set_git_state_color
            echo -n (__current_dir_git_repo_name)

            if begin
                success git log -n 1
                and test (__current_git_branch_name) != "master"
            end
                set_color brgreen
                printf '(%s)' (__current_git_branch_name)
            end

            set_color normal -b normal
            test (builtin pwd) = (git rev-parse --show-toplevel)
                or echo -n (set_color brblue -o)':'(basename (builtin pwd))
        else
            set -l __pwd__ (basename (builtin pwd))
            set_color brblue -o
            printf "%s" (test "$__pwd__" = "/"; and printf '(ROOT)'; or printf $__pwd__)
        end
    end

    test $last_status -eq 0
        and set_color normal
        or  set_color brred
    test (whoami) = 'root'
        and printf '# '
        or  printf '$ '
    set_color normal
end

