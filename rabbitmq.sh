#!/bin/bash
sudo yum install epel-release -y
# RabbitMQ 3.9 from centos-rabbitmq-38 crashes on EPEL's Erlang 26. Hide EPEL's Erlang
# so dnf installs Erlang 24 from the RabbitMQ repo instead (also stops "yum update" pulling 26 back).
grep -q '^excludepkgs=erlang' /etc/yum.repos.d/epel.repo || sudo sed -i '/^\[epel\]$/a excludepkgs=erlang*' /etc/yum.repos.d/epel.repo
sudo yum update -y
sudo yum install wget -y
cd /tmp/
dnf -y install centos-release-rabbitmq-38
 dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
 systemctl enable --now rabbitmq-server
 firewall-cmd --add-port=5672/tcp
 firewall-cmd --runtime-to-permanent
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
sudo systemctl restart rabbitmq-server
