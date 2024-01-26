#!/bin/bash
sudo -i
DATABASE_PASS='admin123'
yum update -y
yum install epel-release -y
yum install git zip unzip -y
yum install mariadb-server -y


# starting & enabling mariadb-server
systemctl start mariadb
systemctl enable mariadb
cd /tmp/
git clone -b local-setup https://github.com/Ibidapo-chad/vprofile-project
#restore the dump file for the application
mysqladmin -u root password "$DATABASE_PASS"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restart mariadb-server
systemctl restart mariadb


#starting the firewall and allowing the mariadb to access from port no. 3306
#systemctl start firewalld
#systemctl enable firewalld
#firewall-cmd --get-active-zones
#firewall-cmd --zone=public --add-port=3306/tcp --permanent
#firewall-cmd --reload
#systemctl restart mariadb
