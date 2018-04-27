
set encoding=utf-8
language C

set lazyredraw
set number
set relativenumber
set fenc=utf-8
set fileformats=unix,dos
set showcmd
set cursorline
set tabstop=4
set softtabstop=4
set expandtab
set breakindent
set shiftwidth=4
set hidden
set virtualedit=block
set whichwrap=b,s,h,l,<,>,[,],~
set backspace=indent,eol,start
set wrap
set display=lastline
set pumheight=10
set mouse=a
set wildmenu
set wildignorecase
set clipboard=unnamedplus
set history=100
set list
set listchars=tab:)\ ,trail:-,eol:\ ,extends:>,precedes:<,nbsp:-
set splitright
set splitbelow
set hlsearch
set foldmethod=marker
set nf=""

let g:mapleader="<Space>"
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap <Up> gk
noremap <Down> gj
noremap <A-Up> <C-b>
noremap <A-Down> <C-f>
noremap <A-Left> 0
noremap <A-Right> $
noremap <C-Left> b
noremap <C-Right> w
nnoremap <C-Up> "zdd<Up>"zP
nnoremap <C-Down> "zdd"zp
vnoremap <C-Up> "zdd<Up>"zP
vnoremap <C-Down> "zdd"zp
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>
noremap + <C-a>
noremap - <C-x>
inoremap <C-Backspace> <ESC>ciw
inoremap <C-Delete> <Space><ESC>ciw
inoremap <C-H> <ESC>ciw
inoremap <C-;> <Delete>
inoremap <C-+> <Space><ESC>ciw
nnoremap <Tab> <C-w>w
nnoremap <BackSpace> <C-w>W
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

