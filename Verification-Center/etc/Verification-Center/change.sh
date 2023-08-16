#!/bin/bash

echo "Enter name of a default Verification center"
VCname() {
read -p "> " name
if [ -d /etc/Verification-Center/$name ]; then
	return
else
	echo "There is no Verification Center with such name. Try again"
	VCname
fi
}

VCname
sed -i 's/VC=/VC='$name'/' /etc/Verification-Center/send.sh
