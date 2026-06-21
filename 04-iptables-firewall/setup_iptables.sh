#!/bin/bash
# iptables Firewall Setup - default-deny policy allowing only
# SSH, HTTP, HTTPS, loopback, and established connections.
# Author: Nicolas Hoyos | Runs on VM2

iptables -F        # flush all existing rules
iptables -X        # delete any custom chains

iptables -A INPUT -i lo -j ACCEPT                                          # loopback
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT     # replies
iptables -A INPUT -p tcp --dport 22 -j ACCEPT                              # SSH (do before DROP)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT                              # HTTP
iptables -A INPUT -p tcp --dport 443 -j ACCEPT                             # HTTPS

iptables -P INPUT DROP        # block all other incoming
iptables -P FORWARD DROP      # block all other forwarded
iptables -P OUTPUT ACCEPT     # allow outgoing (we trust our machine)

# Save with: sudo netfilter-persistent save  (writes rules.v4 / rules.v6)
