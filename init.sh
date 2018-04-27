#!/bin/sh

# not use
return
if [ $(type git > /dev/null; echo $?) -ne 0 ]; then
    read -p "GitName: "  gitName
    read -p "GitEmail: " gitEmail
else
    gitName=$(git config --global user.name)
    gitEmail=$(git config --global user.email)
    if [ "${gitName}${gitEmail}" = "" ]; then
        read -p "GitName: "  gitName
        read -p "GitEmail: " gitEmail
    fi
fi
read -p "Can you get Root? [0/1]" rootable
packageManager=''
requirePackages='fish'
vimPackageName='vim'
distributionName=$(uname -a | grep -oE Ubuntu\|Android\|CentOS)
CurrentDir='~/settings'
if [ ! -d $CurrentDir ]; then
    ExistSettings=1
else
    ExistSettings=0
    CurrentDir=$(cd $(dirname $0) && pwd)
fi

# install packages
case $distributionName in
    'Ubuntu')
        packageManager='sudo apt'
        # uninstall default vim package
        sudo apt purge --auto-remove vim-*
        sudo add-apt-repository -y ppa:pi-rho/dev
        vimPackageName='vim-gtk'
        # install packages
        requirePackages="${requirePackages} cargo xsel ubuntu-make unity-tweak-tool fcitx-mozc"
        sudo add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make
        sudo add-apt-repository -y ppa:nathan-renniewaldock/flux
        ;;
    'Android')
        packageManager='packages'
        requirePackages="${requirePackages} util-linux make clang"
        ;;
    'CentOS')
        packageManager='sudo yum'
        requirePackages="${requirePackages} xsel"
        ;;
esac
installedPackage=1
while :
do
    if [ $(type git > /dev/null; echo $?) -eq 0 ]; then
        ExistGit=0
    elif test $installedPackage -eq 1; then
        ExistGit=1
        requirePackages="${requirePackages} git"
    fi
    if [ $(type curl > /dev/null; echo $?) -eq 0 ]; then
        ExistCurl=0
    elif test $installedPackage -eq 1; then
        ExistCurl=1
        requirePackages="${requirePackages} curl"
    fi
    if [ $(type vim > /dev/null; echo $?) -eq 0 ]; then
        ExistVim=0
    elif test $installedPackage -eq 1; then
        ExistVim=1
        requirePackages="${requirePackages} ${vimPackageName}"
    fi
    if [ $(type ssh > /dev/null; echo $?) -eq 0 ]; then
        ExistSSH=0
    elif test $installedPackage -eq 1; then
        ExistSSH=1
        requirePackages="${requirePackages} openssh"
    fi

    if [ $installedPackage -eq 0 ]; then
        break
    elif [ $requirePackages != "" -a $rootable -eq 0 ]; then
        eval $packageManager update
        eval $packageManager upgrade
        eval $packageManager dist-upgrade
        eval $packageManager install -y $requirePackages
    fi
    installedPackage=0
done



#setting git
if [ $ExistGit -eq 0 ]; then
    git config --global user.name    $gitName
    git config --global user.email   $gitEmail
    git config --global core.editor  vim
    git config --global push.default simple
    if [ $ExistSettings -eq 1 ]; then
        git clone https://github.com/rkbk60/config ~
    fi
fi

#install vim-plug
if [ $ExistCurl -eq 0 -a $ExistVim -eq 0 ]; then
    if [ ! -e ~/.vim/autoload/plug.vim ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        if [ $? -eq 0 ]; then
            mkdir -p ~/.vim/tmp
            mkdir -p ~/.config/nvim
            ln -sf $CurrentDir/vim/vimrc ~/.vimrc
            ln -sf $CurrentDir/vim/vimrg ~/.config/nvim/init.vim
            ln -sf $CurrentDir/vim/gvimrc ~/.gvimrc
            ln -sf $CurrentDir/vim/gvimrc ~/.config/nvim/ginit.vim
        else
            echo \[Notice\] Faild to install vim-plug.
        fi
    else
        mkdir -p ~/.vim/tmp
        mkdir -p ~/.config/nvim
        ln -sf $CurrentDir/vim/vimrc ~/.vimrc
        ln -sf $CurrentDir/vim/vimrc ~/.config/nvim/init.vim
        ln -sf $CurrentDir/vim/gvimrc ~/.gvimrc
        ln -sf $CurrentDir/vim/gvimrc ~/.config/nvim/ginit.vim
    fi
fi

grep "source $CurrentDir/sh/unix-shrc" ~/.bashrc || echo source $CurrentDir/sh/unix-shrc >> ~/.bashrc
grep "source $CurrentDir/sh/profile" ~/.profile || echo source $CurrentDir/sh/profile >> ~/.profile
grep "source $CurrentDir/vim/minimal.vim" ~/.ideavimrc || echo source $CurrentDir/vim/minimal.vim >> ~/.ideavimrc
mkdir -p ~/.config/fish/functions
grep "source $CurrentDir/fish/config.fish" ~/.config/fish/config.fish || echo source $CurrentDir/fish/config.fish >> ~/.config/fish/config.fish
echo source $CurrentDir/fish/fish_prompt.fish > ~/.config/fish/functions/fish_prompt.fish
ln -sf $CurrentDir/sh/inputrc ~/.inputrc
ln -sf $CurrentDir/gtk/gtkrc-2.0 ~/.gtkrc-2.0
mkdir -p ~/.config/terminator && ln -sf $CurrentDir/terminal/terminator-config ~/.config/terminator/config
[ $(type cargo > /dev/null; echo $?) -eq 0 ] && cargo install ripgrep -f
[ -e $CurrentDir/ssh/establ.sh -a $ExistSSH -eq 0 ] && sh $CurrentDir/ssh/establ.sh

#EOS

