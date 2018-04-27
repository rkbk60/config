
# not using now
return
$tmpDir = '~\inittmp'
$stepLog = "$tmpDir\step"
$restartPath = "~\init.bat"

function setRegist($path, $name, $value) {
    $truepath = "$path\$name"
    if (Test-Path $truepath) {
        Set-ItemProperty -Path $path -Name $name -Value $value
    } else {
        New-ItemProperty -Path $path -Name $name -Value $value
    }
}

function setAutoLogon($flag) {
    $regPath = 'HKLM:\SOFTWARE\Microsoft\Windwos NT\CurrentVersion\Winlogon'
    if ($bool) {
        $autologon = 1
            $password = cat ~\inittmp\password
    } else {
        $autologon = 0
            $password = ''
    }
    setRegist $regPath 'AutoAdminLogon'  $autologin
    setRegist $regPath 'DefaultPassword' $password
}

function reboot($nextStepNum, $restartPath, $stepLogDir) {
    setAutoLogon 1
    $registPath = "HKLM:\SOFTWARE\Windows\CurrentVersion"
    $registName = "RunOnce"
    setRegist $registPath $registName $restartPath
    echo $nextStepNum >> $stepLogDir
    Restart-Computer
}



if (Test-Path $stepLog) {
    $step = cat $stepLog -last 1
} else {
    md $tmpDir
    echo 'powershell -Command "Start-Process powershell -Verb runas %USERPROFILE%\init.bat"' > $restartPath
    echo 0 > $stepLog
    $password = Read-Host "Input Password"
    echo $password > $tmpDir\password
    $step = 0
}

switch ($step) {
    # Install Chocolatey
    0 {
        if (-! (gcm git -ea SilentlyContinue) -and -! (Test-Path $tmpDir\gitconfig\)) {
            md $tmpDir\gitconfig
            $gitName = Read-Host "Input your git-name."
            echo $gitName > $tmpDir\gitconfig\gitname
            $gitEmail = Read-Host "Input your git-email."
            echo $gitEmail > $tmpDir\gitconfig\gitemail
        }
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        reboot 1 $restartPath $stepLog
    }
    # Install Packages with Chocolatey
    1 {
        cinst openssh opera ag -y
        reboot 2 $restartPath $stepLog
    }
    # other settings
    2 {
        # Install vim-plug
        md ~\vimfiles\autoload
        $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        (New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("~\vimfiles\autoload\plug.vim"))

        # make tmp folder for vim
        md ~\vimfiles\tmp

        # install dotfiles and make link
        git clone https://github.com/rkbk60/settings ~
        echo "source ~\settings\vim\vimrc"  >> ~\_vimrc
        echo "source ~\settings\vim\gvimrc" >> ~\_gvimrc

        # Git settings
        if (Test-Path $tmpDir\gitconfig\) {
            $gitName  = cat $tmpDir\gitconfig\gitname
            $gitEmail = cat $tmpDir\gitconfig\gitemail
        } else {
            $gitName  = git config --global user.name
            $gitEmail = git config --global user.email
        }
        git config --global user.name    $gitName
        git config --global user.email   $gitEmail
        git config --global core.editor  gvim
        git config --global push.default simple

        # Install Caps2Ctrl
        $dirCC = "$tmpDir\c2c"
        $zipCC = "$dirCC\c2c.zip"
        ier http://download.sysinternals.com/files/Ctrl2Cap.zip -outFile $zipCC
        Expand-Archive -Path $zipCC -DestinationPath $dirCC -Force
        cd $dirCC
        .\install.exe

        reboot 999 $restartPath $stepLog #goto default
    }
    default {
        setAutoLogon 0
        rm -fR $tmpDir
        Set-ExecutionPolicy RemoteSigned
    }
}


# EOS

