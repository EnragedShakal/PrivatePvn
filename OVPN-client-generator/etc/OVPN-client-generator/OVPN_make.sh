#!/bin/bash

#Variables
WorkDir=/etc/OVPN-client-generator


#Request file name
FileName() {
echo "Enter file name. Type \"exit\" for exit"
read -p "> " name
if [[ $name == "exit" || $name == "Exit" ]]; then
	echo "Exiting..."
	exit
elif [ -z "$name" ]; then
	echo "File name can't be blank. Try again"
	FileName
else
	return
fi
}

#Request a name of .crt file
Name(){
echo "Enter a name of "
}

#Request path for generated file
Path() {
echo "Enter path for generated file. Type \"exit\" for exit"
read -p "> " path
if [[ $path == "exit" || $path == "Exit" ]]; then
        echo "Exiting..."
        exit
elif [ -d $path ]; then
	return
else
	echo "Invalid path or directory doesn't exist. Try again"
	Path
fi
}

#Generate .ovpn file
OVPNGenerate() {
cat ./base.conf \
	<(echo -e '<ca>') \
	$WorkDir/pki/ca.crt \
	<(echo -e '</ca>\n<cert>') \
	$WorkDir/pki/issued/$name.crt \
	<(echo -e '</cert>\n<key>') \
	$WorkDir/pki/private/$name.key \
	<(echo -e '</key>\n<tls-crypt>') \
	$WorkDir/ta.key \
	<(echo -e '</tls-crypt>') \
	> $path/$name.ovpn
}


#Main
FileName
Path
OVPNGenerate
echo "All done! ☻"
echo "Generated ${path}$name.ovpn"
