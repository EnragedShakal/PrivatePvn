#!/bin/bash

#Variables
WorkDir=/etc/Verification-Center
host="[ip]"
user="ftp"

#Request name of VC
vcname() {
echo "Enter name of a verification center. Type \"exit\" for exit"
read -p "> " name
if [[ $name == "Exit" || $name == "exit" ]]; then
	echo "Exiting..."
	exit
elif [ -z "$name" ]; then
	echo "Name cannot be blank. Try again"
	vcname
elif [ -d $WorkDir/$name ]; then
	return
else
	echo "Verification center with such name doesn't exist. Try again"
	vcname
fi
}

#Send file via ftp
ftpSend() {
ftp -n $host <<END_SCRIPT
quote USER $user
bin
put $WorkDir/$name.tar.gz /vcs/$name.tar.gz
quit
END_SCRIPT
}

#Show all available VC's
echo "Here are all available VC's:"
find /etc/Verification-Center/ -type d -exec sed 's/\/etc\/Verification-Center\///g' {} \;


#main
vcname
tar cfvz $WorkDir/$name.tar.gz $WorkDir/$name > /dev/null
ftpSend
rm $WorkDir/$name.tar.gz
