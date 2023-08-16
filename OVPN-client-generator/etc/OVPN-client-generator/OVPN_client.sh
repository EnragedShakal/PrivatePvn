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
WorkDir=/etc/OVPN-client-generator

#Request a name of file
Name(){
echo "Enter a name for a file"
read -p "> " name
if [ -z "$name"]; then
	echo "Name can't be blank. Try again."
	Name
else
	return
fi
}

#Generate client key and req files
GenerateClientFiles() {
$RsaExe gen-req $name nopass
}

#Main
cd $WorkDir
Name
GenerateClientFiles
/etc/OVPN-client-generator/send.sh $WorkDir/pki/reqs/$name.req
