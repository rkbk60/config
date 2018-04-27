set fish_greeting

# set base16 color
if status --is-interactive
    test -f $HOME"/.config/base16-shell/scripts/base16-spacemacs.sh"
    and eval sh $HOME/.config/base16-shell/scripts/base16-spacemacs.sh
end

function cls
    clear
end

function gitus
    git rev-parse > /dev/null 2>&1
    if test $status -eq 0
        git status --porcelain
        test -n (echo (git status --porcelain))
            and echo
        echo "[Root] "(git rev-parse --show-toplevel)
        test (pwd) != (git rev-parse --show-toplevel)
            and echo "[now] ~/"(git rev-parse --show-prefix)
        echo "[Branch] "(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
        test (git log -1 1> /dev/null 2> /dev/null; echo $status) -eq 0
            and echo "[Commit] "(git log -1 --pretty="%h(%cr)" 2> /dev/null; or echo -n '(No commits)')
            and test -n (git log -1 --pretty="%s" | sed 's/\s//g')
            and echo "  >> "(git log -1 --pretty="%s")
        test -n (echo (__current_git_remote_name))
            and echo "[Remote] "(__current_git_remote_name): (git remote get-url --push (__current_git_remote_name))
        return 0
    else
        echo "[Notice] Here is not Git repository."
        return 1
    end
end

function __get_prompt_symbol
    if test (whoami) = 'root'
        echo -n '#'
    else
        echo -n '$'
    end
end

function __set_git_state_color
    git status --porcelain | grep -E . > /dev/null
        and set_color brred
        and return 0
    git log (printf '%s/%s' (__current_git_remote_name) master)..HEAD  2> /dev/null | grep -E . > /dev/null
        and set_color bryellow
        or  set_color brgreen
end

function __current_git_branch_name
    git log -1 > /dev/null 2>&1
    test $status -eq 0
        and echo -n (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
end

function __current_git_remote_name
    git rev-parse > /dev/null 2>&1
    test $status -eq 0
        and echo -n (git remote show 2> /dev/null)
end

function __current_dir_git_info
    git rev-parse > /dev/null 2>&1
    if test $status -eq 0
        __set_git_state_color
        echo -n (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
        set_color normal
    end
end

function __current_dir_git_repo_name
    git rev-parse > /dev/null 2>&1
    test $status -eq 0
        and echo -n (basename (git rev-parse --show-toplevel))
end

function __custom_prompt_pwd
    test (builtin pwd) = $HOME
        and return 0
    git rev-parse > /dev/null 2>&1
    if test $status -eq 0
        __set_git_state_color
        echo -n (__current_dir_git_repo_name)
        set_color brgreen
        git log -n 1 > /dev/null 2>&1
        test $status -eq 0
            and test (__current_git_branch_name) != "master"
            and echo -n :(__current_git_branch_name)
        set_color normal
        test (builtin pwd) = (git rev-parse --show-toplevel)
            or echo -n (set_color brblue)':'(basename (builtin pwd))
    else
        echo -n (set_color brblue)(basename (builtin pwd))
    end
    set_color normal
end

