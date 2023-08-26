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

#Allowing All Incoming HTTP and HTTPS
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Allow alll Incoming SSH
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT


