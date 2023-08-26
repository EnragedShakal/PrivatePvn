#!/bin/bash

#$1 - путь к папке /home/File/client/192.168.0.1

#Variables
host="[ip]"
user="ftp"
path=$1
user_ip=$(echo $path | sed 's/\/var\/ftp\/client\///g')
req_name=$(find ${path}/ -mindepth 1 -maxdepth 1 -type f -name "*.req" | sed 's/\/var\/ftp\/client\/'$user_ip'\///g')
log_file=$(date +"%d-%m-%Y %H:%M:%S.log")

#Send file via ftp
ftpSend(){
ftp -n -i $host <<END_SCRIPT
quote USER $user
bin
mkdir /reqs/$user_ip
put $path/$req_name /reqs/$user_ip/$req_name
quit
END_SCRIPT
}

#Main
if [ "`ping -c 1 $host`" ]; then 
	ftpSend
	exit 0
else
	cp $path/$req_name /etc/ovpn_ftp/unprocessed_files/$user_ip-$req_name
	echo "Error occured while processing $req_name from $user_ip." >> /var/logs/vpn_ftp/$log_file
	exit 1
