#!/bin/bash

#PreCheck for openvpn and easy-rsa install
if [[ "$(dpkg -s easy-rsa | grep Status)" == *"install ok"* ]]; then
	echo "Easy-rsa: Installed"
	if [[ "$(dpkg -s openvpn | grep Status)" == *"install ok"* ]]; then
		echo "OpenVPN: Installed"
	else
		echo "OpenVPN: Not installed"
		echo "Terminating.."
		exit 1
	fi
	else
		echo "Easy-rsa: Not installed"
		echo "Terminating..."
		exit 1
fi

#Variables
vcpath=/etc/Verification-Center
ovpnpath=/etc/openvpn
RsaExe=$(whereis easy-rsa | sed 's/easy-rsa: //i')/easyrsa


#Request a verification center name
VCName() {
echo "Enter verification center name. Type \"exit\" for exit."
read -p "> " vcname
if [[ $vcname == "Exit" || $vcname == "exit" ]]; then
	echo "Exiting..."
	exit
elif [ -e $vcpath/$vcname ]; then
	if [ -e $vcpath/$vcname/pki/ca.crt ]; then
		if [ -e $vcpath/$vcname/ta.key ]; then
			return
		else
			echo "Verification center isn't complete. ta.key is missing. Try again."
			VCName
		fi
	else
		echo "Verification center isn't complete. ca.crt is missing. Try again."
		VCName
	fi
else
	echo "Verification center with such name doesn't exitst. Try again."
	VCName
fi
}

#Request a server name
ServerName() {
echo "Enter server name. Type \"exit\" fo exit."
read -p "> " sname
if [ -e $ovpnpath/$sname ]; then
	echo "Server with such name already exists. Try again."
	ServerName
else
	mkdir $ovpnpath/$sname && return || echo "Error! Can't create a directory with such name" && exit 1
	return
fi
}

#Create server key and server crt
CreateServerFiles() {
cd $vcpath/$vcname
$RsaExe gen-req $sname nopass
$RsaExe sign-req server $sname
return
}

#Copy all server related files into ovpn server directory
CopyServerFiles() {
cp $vcpath/$vcname/pki/issued/$sname.crt $ovpnpath/$sname/
cp $vcpath/$vcname/pki/private/$sname.key $ovpnpath/$sname/ 
cp $vcpath/$vcname/pki/ca.crt $ovpnpath/$sname/
cp $vcpath/$vcname/ta.key     $ovpnpath/$sname/
cp /usr/share/doc/OVPN-server-generator/server.conf $ovpnpath/$sname/ 
return
}

#Main
VCName
ServerName
CreateServerFiles
CopyServerFiles
echo "All done! ☻"


