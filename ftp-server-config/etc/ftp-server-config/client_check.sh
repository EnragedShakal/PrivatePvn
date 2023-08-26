#!/bin/bash

WorkDir=/var/ftp/client

find $WorkDir -mindepth 1 -maxdepth 1 -type d -mmin 1 -exec ./send.sh {} \; &>/dev/null
