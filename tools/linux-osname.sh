#!/bin/sh

if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
	if [ -e /etc/lsb-release ]; then
		echo 'ubuntu'
	else
		echo 'debian'
	fi
elif [ -e /data/data/com.termux/files/home ]; then
	echo 'android'
elif [ -e /etc/fedora-release ]; then
	echo 'fedora'
elif [ -e /etc/redhat-release ]; then
	if [ -e /etc/oracle-release ]; then
		echo 'oracle'
	elif [ -e /etc/centos-release ]; then
		echo 'centos'
	else
		echo 'redhat'
	fi
elif [ -e /etc/arch-release ]; then
	echo 'arch'
else
	echo 'unknown'
fi
