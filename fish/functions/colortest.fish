function colortest
    set_color white -b red      ; echo " color test: red       "; set_color normal -b normal
    set_color white -b green    ; echo " color test: green     "; set_color normal -b normal
    set_color white -b yellow   ; echo " color test: yellow    "; set_color normal -b normal
    set_color white -b blue     ; echo " color test: blue      "; set_color normal -b normal
    set_color white -b magenta  ; echo " color test: magenta   "; set_color normal -b normal
    set_color white -b cyan     ; echo " color test: cyan      "; set_color normal -b normal
    set_color black -b white    ; echo " color test: white     "; set_color normal -b normal
    set_color white -b brblack  ; echo " color test: brblack   "; set_color normal -b normal
    set_color black -b brred    ; echo " color test: brred     "; set_color normal -b normal
    set_color black -b brgreen  ; echo " color test: brgreen   "; set_color normal -b normal
    set_color black -b bryellow ; echo " color test: bryellow  "; set_color normal -b normal
    set_color black -b brblue   ; echo " color test: brblue    "; set_color normal -b normal
    set_color black -b brmagenta; echo " color test: brmagenta "; set_color normal -b normal
    set_color black -b brcyan   ; echo " color test: brcyan    "; set_color normal -b normal
    set_color black -b brwhite  ; echo " color test: brwhite   "; set_color normal -b normal
    set_color normal -b normal
    if set -q __onedark_black
        echo
        echo "OneDark:"
        echo "  black:     $__onedark_black"
        echo "  red:       $__onedark_red"
        echo "  green:     $__onedark_green"
        echo "  yellow:    $__onedark_yellow"
        echo "  blue:      $__onedark_blue"
        echo "  magenta:   $__onedark_magenta"
        echo "  cyan:      $__onedark_cyan"
        echo "  white:     $__onedark_white"
        echo "  brblack:   $__onedark_black"
        echo "  brred:     $__onedark_red"
        echo "  brgreen:   $__onedark_green"
        echo "  bryellow:  $__onedark_yellow"
        echo "  brblue:    $__onedark_blue"
        echo "  brmagenta: $__onedark_magenta"
        echo "  brcyan:    $__onedark_cyan"
        echo "  brwhite:   $__onedark_white"
    end
end
