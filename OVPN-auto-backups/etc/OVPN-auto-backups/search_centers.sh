#!/bin/bash

find /etc/Verification-Center/ -maxdepth 1 -mindepth 1 -type d -exec /etc/OVPN-auto-backups/backup_vc.sh private key {} \; -exec /etc/OVPN-auto-backups/backup_vc.sh issued crt {} \; &>/dev/null
