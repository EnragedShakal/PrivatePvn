#!/bin/bash

#$1 - path inside verification center (private|issued)
#$2 - type of searched file (crt|key)
#$3 - absolute pathing to verification center root dir

#Variables
file_type=$2
path=$3/pki/$1/
name=$(echo $3 | sed 's/\/etc\/Verification-Center\///')
log_file=/var/log/OVPN-auto-backups/$(date +"%d-%m-%Y %H:%M:%S.log")

#Send file via ftp. Function will be exported. All values of variables will ve distinct from this script's.
ftpSend() {
host="[ip]"
user="ftp"
local_file=$4
file_location=$3
file_type=${2}s
server_name=$1
file_name=$(echo $local_file | sed 's/\/etc\/Verification-Center\/'$server_name'\/pki\/'$file_location'\///g')
ftp -n -i $host <<END_SCRIPT
quote USER $user
bin
cd $file_type
mkdir $server_name
put $local_file /$file_type/$server_name/$file_name
quit
END_SCRIPT
}

#Main
if [ "`ping -c 1 $host`" ]; then
	export -f ftpSend
	find $path -name "*.$file_type" -mmin -30 -type f -exec bash -c "ftpSend $name $file_type $1 \"{}\"" \;
	exit 0;
else
	#Логирование ошибки
	touch $log_file
	echo "Host is unreachable. Next files weren't processed:" > $log_file
	find $path -name "*.$file_type" -mmin -30 -type f -exec echo "$name $1 $file_type" > $log_file {} \;
fi
