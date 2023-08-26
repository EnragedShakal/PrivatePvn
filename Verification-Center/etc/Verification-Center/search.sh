#!/bin/bash

#Variables
WorkDir=/var/ftp/reqs

find $WorkDir -mindepth 1 -maxdepth 1 -type d -exec /etc/Verification-Center/send.sh {} \; -exex rm {} \;

