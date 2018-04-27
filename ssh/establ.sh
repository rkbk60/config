#!/bin/sh
# Key Generation -- to connect Github/Bitbucket with SSH.

[ $(type git > /dev/null; echo $?) -ne 0 ] && return

Name=$(git config --global user.name)
Email=$(git config --global user.email)
distributionName=$(sh $(cd $(dirname $0) && pwd)/linux-osname.sh)

[ ! -e ~/.ssh ] && mkdir ~/.ssh
cd ~/.ssh
[ ! -e ~/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -C $Email

if [ ! -e ~/.ssh/id_rsa.pub ]; then
	echo Faild to create SSH key.
	echo Please set up again.
	return
fi

case $distributionName in
	'ubuntu' | 'centos')
		if [ $(type xsel > /dev/null; echo $?) -eq 0 ]; then
			echo Input Key\(copied clipboard\) at Github/Bitbucket
			cat ~/.ssh/id_rsa.pub | xsel --clipboard --input
		else
			echo Input Key at Github/Bitbucket
			echo -e "Key:\n"; echo; cat ~/.ssh/id_rsa.pub ; echo -e "\n\n"
		fi
		;;
	'android' | *)
		echo Input Key at Github/Bitbucket
		echo -e "Key:\n"; echo; cat ~/.ssh/id_rsa.pub ; echo -e "\n\n"
		;;
esac
echo Github: https://github.com/settings/keys
echo BitBucket: https://bitbucket.org/account/user/$Name/ssh-keys/
case $distributionName in
	'ubuntu' | 'centos')
		cat ~/.ssh/id_rsa.pub | xsel --clipboard --input
		;;
	'android' | *)
		;;
esac
read -p 'Input <Enter> to start test-connection.' void

echo -e "\nssh -T git@github.com"
ssh -T git@github.com

echo -e "\nssh -T git@bitbucket.org"
ssh -T git@bitbucket.org

#EOS

