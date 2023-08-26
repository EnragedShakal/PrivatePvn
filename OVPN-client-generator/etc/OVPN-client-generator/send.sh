#!/bin/bash

file_name=$1
my_ip=$(curl -s 2ip.ru)
host="[ip]"
user="ftp"
WorkDir=/etc/OVPN-client-generator

#Send file via ftp
ftpSend() {
ftp -n -s $host <<END_SCRIPT 
quote USER $user
bin
mkdir /client/$my_ip
put $WorkDir/pki/reqs/$1 /client/$my_ip/$file_name.req
quit
END_SCRIPT
}

#Main
if [ "`ping -c 1 $host`" ]; then
	ftpSend
	echo "Request has been sent succesfuly ☻"
else
	echo "Host is unreachable. Try again later."
	exit 0
fi

