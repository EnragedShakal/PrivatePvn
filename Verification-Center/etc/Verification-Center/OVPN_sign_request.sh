#!/bin/bash

#PreCheck for easy-rsa install
if [[ "$(dpkg -s easy-rsa | grep Status)" == *"install ok"* ]]; then
        echo "Easy-rsa: Installed"
else
        echo "Easy-rsa: Not installed"
        echo "Terminating..."
        exit 1
fi

#Variables
RsaExe=$(whereis easy-rsa | sed 's/easy-rsa: //i')/easyrsa
WorkDir=/etc/Verification-Center

#Request name of Verification center
VCName(){
read -p "> " name

if [[ $name == "exit" || $name == "Exit" ]]; then
	echo "Exiting..."
	exit
elif [ -d $WorkDir/$name ]; then
	return
else
	echo "Verification Center with such name doesn't exist. Try again. Or type \"exit\" fo exit."
	VCName
fi
}

#Search all pending requests
ReqNameCheck() {
read -p "> " input
if [[ $input == "exit" || $input == "Exit" ]]; then
	echo "Exiting..."
	exit
elif [[ -e /var/ftp/reqs/$input ]]; then
	file_name=
	return
else
	echo "invalid path. Try again or type \"exit\" for exit"
	ReqNameCheck
fi
}


#Main
echo "Choose a request that you want to sign"
find /var/ftp/reqs/ -mindepth 2 -exec echo {} \; | sed 's/\/var\/ftp\/reqs\///g'
ReqNameCheck
echo "Choose a VC which will sign the request."
find $WorkDir/ -mindepth 1 -maxdepth 1 -type d -exec echo {} \; | sed 's/'$WokrDir'//g'
VCName
cd $WorkDir/$name
$RsaExe sign-req client client

echo "All done! ☻"


#Запуск скрипта - Высвечивание ip/название - выбор варианта - копирование, подпись, отправка .crt, ca.crt и ta.key пользователю. 
