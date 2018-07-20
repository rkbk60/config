share.setenv("HOME", nyagos.getenv("USERPROFILE"))

share.completion_slash = true

share.alias.cp   = "copy $*"
share.alias.mv   = "move $*"
share.alias.sudo = "%HOME%\\scoop\\shims\\sudo.exe $*"
share.alias.vim  = "gvim $*"

share.suffix = {
    'lua':   ['nyagos', '-f'],
    'luash': ['nyagos', '-f']
}

nyagos.prompt = function(this)
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
