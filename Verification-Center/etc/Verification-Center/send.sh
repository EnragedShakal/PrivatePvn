#!/bin/bash

#$1 - path to directory

#Variables
host="[ip]"
user="ftp"
path=$1
VC="[server_name]"
user_ip=$(echo $path | sed 's/\/var\/ftp\/reqs\///g')
req_name=$(find $path/* | sed 's/\/var\/ftp\/reqs\/'$user_ip'\///g')
crt_name=$($req_name | sed 's/req/crt/g')
log_file=$(date +"%d-%m-%Y %T.log")

#Send file via ftp
ftpSend() {
ftp -n -i $host <<END_SCRIPT
quote USER $user
bin
mkdir /server/$user_ip
put $file /server/$user_ip/$file_name
quit
END_SCRIPT
}

#Main script
Main() {
#Sign request
/etc/Verification-Center/OVPN_sign_request.sh $req_name $VC
#Send ca.crt
file=$VC/pki/ca.crt
file_name=ca.crt
ftpSend
#Send signed crt
file=$VC/pki/issued/$crt_name
file_name=$crt_name
ftpSend
#Send ta.key
file=$VC/ta.key
file_name=ta.key
ftpSend
}


if [ "`ping -c 1 $host`" ]; then
	find $path/* -cmin 1 -exec cp {} /etc/Verification-Center/$VC/pki/reqs \;
	Main
else
	echo "An error occured while processing request from $user_ip" >> /var/logs/Verification-Center/$log_file
	exit 0
fi

