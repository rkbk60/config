set fish_greeting
set -g FISH_CONFIG_PATH (realpath (status filename))

# set variables {{{1
set -x PIPENV_VENV_IN_PROJECT 'true'
#}}}1

# update functions {{{1
set -l fn_from (string replace '/config.fish' '/functions' $FISH_CONFIG_PATH)
set -l fn_to   "$HOME/.config/fish/functions"
ln -sf $fn_from/fish_prompt.fish $fn_to/fish_prompt.fish
find $fn_from/*.fish -maxdepth 0 \
    | string replace -ar '^.*/([^/]*)\.fish.*$' 'ln -s @1$1.fish @2$1.fish ^ /dev/null &' \
    | string replace -a  '@1' $fn_from/ \
    | string replace -a  '@2' $fn_to/ \
    | source
# remove blocken links
find -L $fn_to/ -type l \
    | string replace -r '^(.*)?' 'rm $1 &' \
    | source
#}}}1

# install fisherman automatically {{{1
begin
    not functions -q fisher
    and test (whoami) != 'root'
end
if test $status -eq 0
    set -l fisher_path "$HOME/.config/fish/functions/fisher.fish"
    curl -Lo $fisher_path --create-dirs https://git.io/fisher
    source $fisher_path
    set -l fishfile (dirname_alt $FISH_CONFIG_PATH)/fishfile
    test -f $fishfile
        and fisher (cat $fishfile | string join ' ')
end
#}}}1

# functions, aliases, plugin settings {{{1
function als -a name command
    functions -q balias
        and balias $name "$command"
        or  alias  $name "$command"
end
if functions -q fisher
    if functions -q bd
        als bdc 'bd -c'
        # bdg is defined in ./functions/bdg.fish
        als bdi 'bd -i'
        als bds 'bd -s'
    end
    if type -q fzf
        set -x FZF_DEFAULT_OPTS '--height 60% --reverse --border'
        set -x FILTER 'fzf'
        als f 'fzf'
        function fd
            fzf | string replace -r '^(.*)$' 'cd $1' | source
        end
        function fkill
            ps -e | fzf | string replace -r '^(\d{1,}).*' 'kill -9 $1' | source
        end
        function var -a prompt
            if test -z $prompt
                error "Error: 'var' command requires identifer string."
                return 1
            end
            echo echo -n ( \
                set -n \
                | fzf --prompt="$prompt: " \
                | string replace -r '^(.*)$' '$$$1'\
            ) | source
        end
    end
end
if type -q nvim
    if type -q nvim-qt
        als gnvim 'nvim-qt --no-ext-tabline'
        als qvim  'nvim-qt --no-ext-tabline'
    else if type -q oni
        als gnvim 'oni'
    end
end
if type -q rg
    function rf -a arg -w rg
        rg . --files -g $arg
    end
end
if type -q su
    function fisu -w su
        su --shell=/usr/bin/fish $argv
    end
end
functions -e als
#}}}1

# set onedark colorscheme {{{1
if begin status is-interactive; and functions -q set_onedark; end
    set -l od_option
    if test "$TERM" = "linux"
        set_onedark_color black 000000 16
        set_onedark_color white ffffff 231
    else if set -q VIM
        set od_option '-256'
    else if string match -q 'eterm-*' $TERM
        function fish_title; true; end
    end
    function onedark -w set_onedark
        test "$TERM" = "linux"
            and set_onedark_color black 000000  16
            or  set_onedark_color black default default
        set_onedark_color red       e06c75  204
        set_onedark_color green     98c379  114
        set_onedark_color yellow    default 173
        set_onedark_color blue      61afef  75
        set_onedark_color magenta   c678dd  170
        set_onedark_color cyan      56b6c2  80
        set_onedark_color white     default 145
        set_onedark_color brblack   default 59
        set_onedark_color brred     default default
        set_onedark_color brgreen   default default
        set_onedark_color bryellow  default 186
        set_onedark_color brblue    default 75
        set_onedark_color brmagenta default default
        set_onedark_color brcyan    default 80
        set_onedark_color brwhite   default default
        set_onedark $argv
    end
    onedark $od_option
end
#}}}1

