#!/bin/bash

#$1 - name of request file
#$2 - VC name

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
req_name=$1
VC=$2

#Main
cd $WorkDir/$2
$RsaExe sign-req client $req_name

echo "All done! ☻"
 
