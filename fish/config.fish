set fish_greeting
set -g FISH_CONFIG_PATH (realpath (status filename))

# update functions {{{1
set -l fn_dir (string replace '/config.fish' '/functions' $FISH_CONFIG_PATH)
find $fn_dir/*.fish -maxdepth 0 \
    | string replace -ar '^.*/([^/]*)\.fish.*$' 'ln -s @1$1.fish @2$1.fish ^ /dev/null &' \
    | string replace -a  '@1' $fn_dir/ \
    | string replace -a  '@2' '~/.config/fish/functions/' \
    | source
if not test -L ~/.config/fish/functions/fish_prompt.fish
    ln -sf $fn_dir/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
end
#}}}1

# install fisherman automatically {{{1
begin
    not functions -q fisher
    and test (whoami) != 'root'
end
if test $status -eq 0
    curl -Lo $HOME/.config/fish/fisher.fish --create-dirs https://git.io/fisher
    source $HOME/.config/fish/fisher.fish
    set -l fishfile (dirname $FISH_CONFIG_PATH)/fishfile
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
    if functions -q fzf
        set -x FZF_DEFAULT_OPTS '--height 60% --reverse --border'
        set -x FILTER 'fzf'
        als f 'fzf'
        function fd
            fzf | string replace -r '^(.*)$' 'cd $1' | source
        end
        function fkill
            ps -e | fzf | string replace -r '^(\d{1,}).*' 'kill -9 $1' | source
        end
    end
end
if functions -q nvim
    if functions -q nvim-qt
        als gnvim 'nvim-qt --no-ext-tabline'
        als qvim  'nvim-qt --no-ext-tabline'
    else if functions -q oni
        als gnvim 'oni'
    end
end
if executable su
    function fisu
        /bin/su --shell=/usr/bin/fish $argv
    end
end
functions -e als
#}}}1

# set onedark colorscheme {{{1
if begin status is-interactive; and functions -q set_onedark; end
    set -l od_option
    if test "$TERM" = "linux"
        set_onedark_color black 050505 default
        set_onedark_color white eeeeee default
    else if set -q VIM
        set od_option '-256'
    else if string match -q 'eterm-*' $TERM
        function fish_title; true; end
    end
    # set_onedark $od_option
    function onedark
        set_onedark_color black     262626 default
        set_onedark_color red       ff5f87 204
        set_onedark_color green     87d787 114
        set_onedark_color yellow    d7af87 180
        set_onedark_color blue      00afff 39
        set_onedark_color magenta   d75fd7 170
        set_onedark_color cyan      5fafd7 74
        set_onedark_color white     afafaf 145
        set_onedark_color brblack   5f5f5f 59
        set_onedark_color brred     ff5f87 default
        set_onedark_color brgreen   87d787 default
        set_onedark_color bryellow  d7af87 default
        set_onedark_color brblue    00afff default
        set_onedark_color brmagenta d75fd7 default
        set_onedark_color brcyan    5fafd7 74
        set_onedark -b -256
    end
end
#}}}1

# load optional settings {{{1
test -f "$HOME/.fishrc"
    and source "$HOME/.fishrc"
    or  true
#}}}1
