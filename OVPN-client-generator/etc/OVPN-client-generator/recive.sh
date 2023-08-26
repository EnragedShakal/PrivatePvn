#!/bin/bash

file_name=$1
my_ip=$(curl -s 2ip.ru)
host="[ip]"
user="ftp"
WorkDir=/etc/OVPN-client-generator

#Recieve file via ftp
ftpRecieve() {
ftp -n -s $host<<END_SCRIPT
qoute USER $user
bin
get /server/$my_ip/ca.crt $WorkDir/pki/ca.crt
get /server/$my_ip/$file_name.crt $WorkDir/pki/issued/$file_name.crt
get /server/$my_ip/ta.key $WorkDir/ta.key
quit
END_SCRIPT
}

#Main
if [ "`ping -c 1 $host`" ]; then
	ftpRecieve
	echo "Request signed and recived succesfuly ☻"
else
	echo "Host is unreachable. Try again later."
	exit 0
fi

