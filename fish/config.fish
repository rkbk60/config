set fish_greeting
set -g FISH_CONFIG_PATH (realpath (status filename))

function fish_title; echo "fish terminal"; end
test -f "$HOME/.fishrc"
    and source "$HOME/.fishrc"

# functions, aliases, plugin settings {{{

# pure fish aliases {{{
function success
    set -l last_status "$status"
    if not set -q argv[1]
        return (test $last_status -eq 0)
    end
    switch "$argv[1]"
        case '-p' '--print'
            echo $last_status
            return $last_status
        case '*'
            eval "$argv" > /dev/null ^&1
    end
end

function executable -a command
    success type $command
end

function dirname -a arg
    test -d $arg
        and echo $arg
        or  string replace -r '/[^/]*$' '/' $arg
end

function sync_fishfile
    set -q FISH_CONFIG_PATH; or return 1
    set -l from "$HOME/.config/fish/fishfile"
    set -l to (dirname $FISH_CONFIG_PATH)/fishfile
    test -f $from; and cp -f $from $to
end

function cls; clear; end
function reload_config
    source $FISH_CONFIG_PATH
end
# }}}

# plugin or external-command aliases and settings {{{
if executable fisher
    if executable bd
        balias bdc 'bd -c'
        balias bdi 'bd -i'
        balias bds 'bd -s'
        function bdg
            success git rev-parse; or return
            builtin pwd
            cd (git rev-parse --show-toplevel)
        end
    end
    if executable fzf
        set -x FZF_DEFAULT_OPTS '--height 60% --reverse --border'
        set -x FILTER 'fzf'
        balias f 'fzf'
        function fkill
            ps -e | fzf | string replace -r '^(\d{1,}).*' 'kill -9 $1' | source
        end
    end
    if executable git
        balias g 'git'
    end
    if executable expand-word
        expand-word -p '^foo$' -e '(echo foobar)'
    end
end
if executable git
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
end
# }}}

# }}}

# install fisherman automatically {{{
begin
    not executable fisher
    and test (whoami) != 'root'
end
if success
    curl -Lo $HOME/.config/fish/fisher.fish --create-dirs https://git.io/fisher
    source $HOME/.config/fish/fisher.fish
    set -l fishfile (dirname $FISH_CONFIG_PATH)/fishfile
    test -f $fishfile
        and fisher (cat $fishfile | string join ' ')
    success
        and reload_config
end
# }}}

# set onedark colorscheme {{{
if status is-interactive
    if executable set_onedark
        set -l od_option
        if test "$TERM" = "linux"
            # set_onedark_color black 050505 default
            # set_onedark_color white eeeeee default
        else if set -q VIM
            set od_option '-256'
        else if string match -q 'eterm-*' $TERM
            function fish_title; true; end
        end
        # set_onedark $od_option
        function onedark
            set_onedark_color black   262626 default
            set_onedark_color red     ff5f87 204
            set_onedark_color green   87d787 114
            set_onedark_color yellow  d7af87 180
            set_onedark_color blue    00afff 39
            set_onedark_color magenta d75fd7 170
            set_onedark_color cyan    5fafd7 74
            set_onedark_color white   afafaf 145
            set_onedark_color brblack 5f5f5f 59
            set_onedark_color brred     ff5f87 default
            set_onedark_color brgreen   87d787 default
            set_onedark_color bryellow  d7af87 default
            set_onedark_color brblue    00afff default
            set_onedark_color brmagenta d75fd7 default
            set_onedark_color brcyan    5fafd7 74
            set_onedark -b -256
        end
    end
end
# }}}

# functions for prompt/git-utilities {{{
function __get_prompt_symbol
    test (whoami) = 'root'
        and echo -n '#'
        or  echo -n '$'
end

function __set_git_state_color
    git status --porcelain ^ /dev/null | grep -E . > /dev/null
        and set_color brred -o
        and return 0
    git log (printf '%s/%s' (__current_git_remote_name) (__current_git_branch_name))..HEAD  ^ /dev/null | grep -E . > /dev/null
        and set_color bryellow -o
        or  set_color brgreen  -o
end

function __current_git_branch_name
    success git log -1
        and echo -n (git branch ^ /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
end

function __current_git_remote_name
    success git rev-parse
        and echo -n (git remote show ^ /dev/null)
end

function __current_dir_git_info
    if success git rev-parse
        __set_git_state_color
        echo -n (git branch ^ /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
        set_color normal -b normal
    end
end

function __current_dir_git_repo_name
    success git rev-parse
        and echo -n (basename (git rev-parse --show-toplevel))
end

function __custom_prompt_pwd
    test (builtin pwd) = $HOME
        and return 0
    if success git rev-parse
        __set_git_state_color
        echo -n (__current_dir_git_repo_name)
        set_color brgreen
        success git log -n 1
            and test (__current_git_branch_name) != "master"
            and echo -n \((__current_git_branch_name)\)
        set_color normal -b normal
        test (builtin pwd) = (git rev-parse --show-toplevel)
            or echo -n (set_color brblue -o)':'(basename (builtin pwd))
    else
        set -l __pwd__ (basename (builtin pwd))
        set_color brblue -o
        printf (test "$__pwd__" = "/"; and printf '(ROOT)'; or printf $__pwd__)
    end
    set_color normal
end
# }}}

