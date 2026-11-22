#!/bin/bash
sudo dnf install epel-release -y
sudo dnf install memcached -y
# Listen on IPv4 only. IPv6 is disabled on this box, so the default
# OPTIONS="-l 127.0.0.1,::1" makes memcached fail with "Cannot assign requested address".
sudo sed -i 's/^OPTIONS=.*/OPTIONS="-l 0.0.0.0"/' /etc/sysconfig/memcached
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached
sudo systemctl restart memcached
firewall-cmd --add-port=11211/tcp
firewall-cmd --runtime-to-permanent
firewall-cmd --add-port=11111/udp
firewall-cmd --runtime-to-permanent
sudo memcached -p 11211 -U 11111 -u memcached -d
