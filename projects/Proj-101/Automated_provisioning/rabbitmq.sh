#!/bin/bash
sudo -i
yum install epel-release -y
yum update -y
yum install wget -y
cd /tmp/
wget http://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
yum -y install erlang socat
#Install Rabbitmq Server
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
yum install rabbitmq-server -y
#firewall-cmd --add-port=5672/tcp
#firewall-cmd --runtime-to-permanent
systemctl start rabbitmq-server
systemctl enable rabbitmq-server
systemctl status rabbitmq-server
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator
systemctl restart rabbitmq-server
