" functions using both vimrc/gvimrc

function! IsPlugged(name)
    return exists('g:plugs') && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
endfunction

function! IsAdvanceMode()
    return has('nvim') || (exists('g:advanceMode') && g:advanceMode == 1)
endfunction


function! GetOSName()
    if has('win32')
        return 'windows'
    elseif glob('/etc/debian_version') != '' ||  glob('/etc/debian_release') != ''
        if glob('/etc/lsb-release') != ''
            return 'ubuntu'
        else
            return 'debian'
        endif
    elseif glob('/data/data/com.termux/files/home') != ''
        return 'android'
    elseif glob('/etc/fedora-release') != ''
        return 'fedora'
    elseif glob('/etc/redhat-release') != ''
        if glob('/etc/oracle-release') != ''
            return 'oracle'
        elseif glob('/etc/centos-release') != ''
            return 'centos'
        else
            return 'redhat'
        endif
    elseif glob('/etc/arch-release') != ''
        return 'arch'
    else
        return 'unknown'
    endif
endfunction



function! s:setColor()
    set background=dark
    if g:IsPlugged('onedark.vim')
        color onedark
    endif
endfunction

function! s:setCursorLineHightlight()
    let l:os = g:GetOSName()
    if &term == 'xterm-256color'
        hi Normal guibg=NONE ctermbg=NONE
        hi clear CursorLine
    elseif l:os == 'android'
        "hi Normal guibg=NONE ctermbg=NONE
    endif
endfunction

function! s:setNoticeBarHightlight()
    hi TablineFill cterm=Bold gui=Bold ctermbg=59 guibg=#23282E
    "hi StatusLine cterm=Italic gui=Italic
    hi StatusLineNC cterm=Italic gui=Italic ctermbg=238 guibg=#2C323C
endfunction



function! SetTermVimColor()
    try
        call s:setColor()
        call s:setCursorLineHightlight()
        call s:setNoticeBarHightlight()
    catch
    endtry
endfunction

function! SetTermNvimColor()
    try
        call s:setColor()
    catch
    endtry
endfunction

function! SetGuiVimColor()
    try
        call s:setColor()
        call s:setNoticeBarHightlight()
    catch
    endtry
endfunction

function! SetColor()
    "if has('nvim')
    if 0
        call g:SetTermNvimColor()
    "elseif has('gui_running')
    elseif has('gui_running') || has('nvim')
        call g:SetGuiVimColor()
    else
        call g:SetTermVimColor()
    endif
endfunction

