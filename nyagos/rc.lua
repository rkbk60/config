nyagos.setenv("HOME", nyagos.getenv("USERPROFILE"))

nyagos.completion_slash = true

-- unix shell like aliases.
nyagos.alias.cp  = "copy $*"
nyagos.alias.mv  = "move $*"
nyagos.alias.rm  = "del $*"
nyagos.alias.la  = "ls -a $*"
nyagos.alias.ll  = "ls -l $*"
nyagos.alias.cat = "type $*"

-- scoop aliases like chocolatey.
nyagos.alias.sup = 'scoop update; scoop update *'
nyagos.alias.sin = 'scoop install $*'
nyagos.alias.sun = 'scoop uninstall $*'
nyagos.alias.sea = 'scoop search $*'
nyagos.alias.sls = 'scoop list'
nyagos.alias.sst = 'scoop status'
nyagos.alias.sbu = 'scoop bucket $*'

-- other aliases.
nyagos.alias.bim    = "bash -c \"vim $*\""
nyagos.alias.fish   = "bash -c fish"
nyagos.alias.pwsh   = "powershell $*"
nyagos.alias.sha256 = "certutil -hashfile $* SHA256"
nyagos.alias.tig    = "bash -c tig"
nyagos.alias.vim    = "gvim $*"

nyagos.prompt = function(_)
    local wd = nyagos.getwd()
    local env = nyagos.env
    local home = env.home or env.userprofile
    local home_len = home:len()
    if wd:sub(1, home_len) == home then
        wd = "~" .. wd:sub(home_len + 1)
    end
    local code = nyagos.elevated() and 45 or 46 -- magenta/cyan
    local head = "\n$e[" .. code .. ";30;1m $e[40;37;0m "
    local prompt = wd == "~" and head or head .. wd .. head
    return nyagos.default_prompt(prompt, "Nyagos: " .. wd)
end

function bd(str, opt)
    local oldpwd = nyagos.eval("pwd")
    local newpwd = oldpwd
    local div = share.completion_slash and "/" or "\\"

    local function split(str, div)
        local div, fields = div or ",", {}
        local pattern = str:format("([^%s]+)", div)
        str:gsub(pattern, function(c) fields[#fields + 1] = c end)
        return fields
    end

    if opt == "i" then
        local t = split(oldpwd, div)
        local n = #t
        for i = 1, n - 1 do
            if str:lower():gmatch(t[i]:lower()..".*") then
                n = i
                break
            end
        end
        newpwd = table.concat(t, div, 1, n)
    elseif opt == "n" then
        if not string.gmatch(tostring(str), "%d*") then
            nyagos.write("Invalid argument.")
            return
        end
        local t = split(oldpwd, div)
        newpwd = table.concat(t, div, 1, math.min(#t, tonumber(str)))
    elseif opt == "c" then
        local d = div
        newpwd = oldpwd:gsub("(.*"..div..str..div..").*", "%1") or oldpwd
    elseif opt == "s" then
        local d = div
        newpwd = oldpwd:gsub(
            "(.*"..d.."[^"..d.."]+"..str.."[^"..d.."]*"..d..").*", "%1") or oldpwd
    else
        nyagos.exec("echo " .. oldpwd:gsub("(.*"..div..str..div..").*", "%1"))
        nyagos.exec("cd ..")
        return
    end
    if newpwd == oldpwd then
        nyagos.exec("echo 'No such occurence.'")
    else
        nyagos.exec("echo " .. newpwd)
        nyagos.exec("cd " .. newpwd)
    end
end
-- vim: set ft=lua: --
