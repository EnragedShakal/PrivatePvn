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
RsaExe=$(whereis easy-rsa | sed 's/easy-rsa: //i')/easyrsa

#Request desired path from user
Name() {
read -p "Enter desired name: " name
if [ -z "$name" ]; then
	echo "Name cannot be empty."
	Name
else
	path=/etc/Verification-Center/$name
	return
fi
}

#Contents of VARS files
Vars() {
	read -p "Enter Country: "     country;
	read -p "Enter Province: "    province;
	read -p "Ener City: "         city;
	read -p "Enter Organization name: " org;
	read -p "Enter Email: "       email;
	read -p "Enter Organization Unit: " ou;
	echo "if [ -z \"'\$EASYRSA_CALLER'\" ]; then
	      echo \"You appear to be sourcing an Easy-RSA 'vars' file.\" >&2
	      echo \"This is no longer necessary and is disallowed. See the section called\" >&2
	      echo \"'How to use this file' near the top comments for more details.\" >&2
	      return 1
	      fi
	      set_var EASYRSA_REQ_COUNTRY     \"$country\"
	      set_var EASYRSA_REQ_PROVINCE    \"$province\"
	      set_var EASYRSA_REQ_CITY        \"$city\"
	      set_var EASYRSA_REQ_ORG         \"$org\"
	      set_var EASYRSA_REQ_EMAIL       \"$email\"
	      set_var EASYRSA_REQ_OU          \"$ou\"
	      set_var EASYRSA_ALGO            ec
	      set_var EASYRSA_DIGEST          \"sha512\"" > $path/vars
}

Check() {
if [ -e $path/pki/ca.crt ]; then
	echo "Verification center with such name already exist. Exiting..."
	exit 1
else
	return
fi
}

#Main
Name
Check
mkdir $path || path=/etc/Verification-Center/Default mkdir $path 
cd $path
$RsaExe init-pki
Vars
$RsaExe build-ca
openvpn --genkey --secret ta.key
echo "All done! ☻"
