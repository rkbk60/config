
$Name = "rkbk60"
$Email = Read-Host "Input your global email address"

ssh-keygen -t rsa -C $Email

if (Test-Path ~\.ssh\id_rsa.pub) {
	cat ~\.ssh\id_rsa.pub | clip
	echo Input Key at Github and Bitbucket
	echo Github: https://github.com/settings/keys
	echo BitBucket: https://bitbucket.org/account/user/$Name/ssh-keys/
	$test = Read-Host "Do you want to test? [Y/N]"
	if ($test -match [yY]) {
		echo ssh -T git@github.com
		ssh -T git@github.com
		echo ssh -T git@bitbucket.org
		ssh -T git@bitbucket.org
		$void = Read-Host ""
	}
} else {
	echo Faild to create ssh-key
	$void = Read-Host ""
}
