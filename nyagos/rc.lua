share.setenv("HOME", nyagos.getenv("USERPROFILE"))

share.completion_slash = true

local dotfiles = '%HOME%\\doftiles'
share.alias {
    -- unix shell like aliases.
    cp  = "copy $*",
    mv  = "move $*",
    rm  = "del $*",
    ls  = "ls -c $*",
    la  = "ls -a $*",
    ll  = "ls -l $*",
    cat = "type $*",

    -- scoop aliases like pacman.
    Syu = 'scoop update; scoop update *',
    Ss  = 'scoop install $*',
    Srs = 'scoop uninstall $*',
    Sss = 'scoop search $*',
    Sls = 'scoop list',

    -- dotfiles related commands.
    config   = 'dotfiles nyagos\\rc.lua',
    dotfiles = 'start.exe '..dotfiles..' bash -c "vim $*"',
    editrc   = 'dotfiles nyagos\\rc.lua',

    -- other aliases.
    fish  = "bash -c fish",
    pwsh  = "powershell $*",
    vim   = "gvim $*",
}

share.suffix {
    lua   = 'nyagos -f',
    luash = 'nyagos -f',
}

nyagos.prompt = function(_)
    local wd = nyagos.getwd()
    local env = nyagos.env
    local home = env.home or env.userprofile
    local home_len = home:len()
    if wd:sub(1, home_len) == home_len then
        wd = "~" .. wd:sub(home_len + 1)
    end
    local code = nyagos.elevated() and 45 or 46 -- magenta/cyan
    local head = "\n$e[" .. code .. ";30;1m $e[40;37;0m "
    local prompt = wd == "~" and head or head .. wd .. head
    return nyagos.default_prompt(prompt, "Nyagos: " .. wd)
end

-- vim: set ft=lua: --
