function __set_git_state_color
    git status --porcelain ^ /dev/null | grep -E . > /dev/null
        and set_color -o brred
        and return 0
    git log (printf '%s/%s' (__current_git_remote_name) (__current_git_branch_name))..HEAD ^ /dev/null | grep -E . > /dev/null
        and set_color -o bryellow
        or  set_color -o brgreen
end
