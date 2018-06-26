function gitus
    if success git rev-parse
        git status --porcelain
        success; and echo
        echo "[Root] "(git rev-parse --show-toplevel)
        test (builtin pwd) != (git rev-parse --show-toplevel)
            and echo "[now] ~/"(git rev-parse --show-prefix)
        echo "[Branch] "(git branch ^ /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
        success git log -1
            and echo "[Commit] "(git log -1 --pretty="%h(%cr)" ^ /dev/null; or echo -n '(No commits)')
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
