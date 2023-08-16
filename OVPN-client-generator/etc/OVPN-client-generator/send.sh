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

#Simple 1.5 min timer
timer() {
	min=1
	sec=30
	while [ $min -ge 0 ]; do
		while [ $sec -ge 0 ]; do
			echo -ne "$min:$sec\033[0K\r"
			let "sec=sec-1"
			sleep 1
		done
		sec=59
		let "min=min-1"
	done
	return
}

#Main
if [ "`ping -c 1 $host`" ]; then
	ftpSend
	echo "Pls, wait for requiest to be signed."
	timer
	ftpGet
	echo "Request signed succesfuly ☻"
else
	echo "Host is unreachable. Try again later."
	exit 0
fi

