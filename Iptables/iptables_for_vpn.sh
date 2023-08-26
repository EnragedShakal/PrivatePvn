#!/bin/bash

eth=$1

#Allowing Established and Related Incoming Connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#Allowing Loopback Connections
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#Dropping Invalid Packets
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

#Allow Outgoing SMTP
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT

#Allow Prometheus Node Exporter
iptables -A INPUT -p tcp --dport 9100 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

#Allow Prometheus OpenVPN Exporter
iptables -A INPUT -p tcp --dport 9176 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

#Allowing All Incoming HTTP and HTTPS
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#OpenVPN
iptables -A INPUT -i "@eth" -m state --state NEW -p udp --dport 1194 -j ACCEPT
iptables -A INPUT -i "@eth" -m state --state NEW -p udp --dport 1194 -j ACCEPT

#Allow TUN interface connections to OpenVPN server
iptables -A INPUT -i tun+ -j ACCEPT

#Allow TUN interface connections to be forwarded through other interfaces
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A FORWARD -i tun_ -o "$eth" -m state --state RELATED,ESTABLISHED -j ACCEPT

#NAT the VPN client traffic to the internet
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$eth" -j MASQUERADE

#Allow alll Incoming SSH
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT


