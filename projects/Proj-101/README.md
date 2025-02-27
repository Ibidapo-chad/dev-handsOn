# Project 101 setup

This is project defines a manual setup of VMs running separate different services.

## Prerequisite
1. Oracle VM Virtualbox
1. Vagrant
1. Vagrant plugins
    - `vagrant plugin install vagrant-hostmanager`
    - `vagrant plugin install vagrant-vbguest`
1. Git bash or equivalent editor

## VM Setup
1. Clone source code.
1. Cd into the repository.
1. Switch to the main branch.
1. cd into vagrant/ Manual_provisioning directory
> [!NOTE]<br/>
> Bringing up all the vm’s may take a long time based on various factors.
If vm setup stops in the middle run “vagrant up” command again.

## SYSTEM DESIGN DIAGRAM
___

![Web Design Architecture](./SysDesignDiag.svg)

## Provisioning 
### Services / Stack
1. Nginx            =>  Web Service
2. Tomcat           =>  Application Server
3. RabbitMQ         =>  Broker/Queuing Agent
4. Memcache         =>  DB Caching
5. ElasticSearch    =>  Indexing/Search service
6. MySQL            =>  SQL Database

Setup should be done in the following order:
* MySQL
(Database SVC)
* Memcache (DB Caching SVC)
* RabbitMQ (Broker/Queue SVC)
* Tomcat
(Application SVC)
* Nginx
(Web SVC)


## 1. MYSQL SETUP
Login to the db vm<br/>
`$ vagrant ssh db01`

Verify Hosts entry, if entries missing update the it with IP and hostnames<br/>
`# cat /etc/hosts`

Update OS with latest patches<br/>
`# yum update -y`

Set Repository<br/>
`# yum install epel-release -y`

Install Maria DB Package<br/>
`# yum install git mariadb-server -y`

Starting & enabling mariadb-server

```
# systemctl start mariadb
# systemctl enable mariadb
```

> [!NOTE]<br/>
> Set db root password, I will be using admin123 as password

Set DB name and users.

`# mysql -u root -padmin123`

```
mysql> create database accounts;
mysql> grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123';
mysql> FLUSH PRIVILEGES;
mysql> exit;
```
Download Source code & Initialize Database.
```
#git clone -b main https://github.com/hkhcoder/vprofile-project.git

#cd vprofile-project

#mysql -u root -padmin123 accounts < src/main/resources db_backup.sql

#mysql -u root -padmin123 accounts
```
```
mysql> show tables;
mysql> exit;
```
Restart mariadb-server

`# systemctl restart mariadb`

Starting the firewall and allowing the mariadb to access from port no. 3306
```
#systemctl start firewalld

#systemctl enable firewalld

#firewall-cmd --get-active-zones

#firewall-cmd --zone=public --add-port=3306/tcp --permanent

#firewall-cmd --reload

#systemctl restart mariadb
```

## 2. MEMCACHE SETUP
Login to the Memcache vm<br/>
`$ vagrant ssh mc01`

Verify Hosts entry, if entries missing update the it with IP and hostnames<br/>
`# cat /etc/hosts`

Update OS with latest patches<br/>
`# yum update -y`

Install, start & enable memcache on port 11211
```
#sudo dnf install epel-release -y

#sudo dnf install memcached -y

#sudo systemctl start memcached

#sudo systemctl enable memcached

#sudo systemctl status memcached

#sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

#sudo systemctl restart memcached
```
Starting the firewall and allowing the port 11211 to access memcache
```
#firewall-cmd --add-port=11211/tcp

#firewall-cmd --runtime-to-permanent

#firewall-cmd --add-port=11111/udp

#firewall-cmd --runtime-to-permanent

#sudo memcached -p 11211 -U 11111 -u memcached -d
```

## 3. RABBITMQ SETUP
Login to the RabbitMQ vm<br/>
`$ vagrant ssh rmq01`

Verify Hosts entry, if entries missing update the it with IP and hostnames<br/>
`# cat /etc/hosts`

Update OS with latest patches<br/>
`# yum update -y`

Set EPEL Repository<br/>
`# yum install epel-release -y`

Install Dependencies
```
#sudo yum install wget -y

#cd /tmp/

#dnf -y install centos-release-rabbitmq-38

#dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server

#systemctl enable --now rabbitmq-server
```

Setup access to user test and make it admin
```
# sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
# sudo rabbitmqctl add_user test test
# sudo rabbitmqctl set_user_tags test administrator# sudo systemctl restart rabbitmq-server
```

Starting the firewall and allowing the port 5672 to access rabbitmq
```
# firewall-cmd --add-port=5672/tcp
# firewall-cmd --runtime-to-permanent
# sudo systemctl start rabbitmq-server
# sudo systemctl enable rabbitmq-server
# sudo systemctl status rabbitmq-server
```

## 4. TOMCAT SETUP
Login to the tomcat vm<br/>
`$ vagrant ssh app01`

Verify Hosts entry, if entries missing update the it with IP and hostnames<br/>
`# cat /etc/hosts`

Update OS with latest patches<br/>
`# yum update -y`

Set Repository<br/>
`# yum install epel-release -y`

Install Dependencies<br/>
```
# dnf -y install java-11-openjdk java-11-openjdk-devel
# dnf install git maven wget -y
```

Change dir to /tmp
```
# cd /tmp/Download & Tomcat Package
# wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
# tar xzvf apache-tomcat-9.0.75.tar.gz
```

Add tomcat user<br/>
`# useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat`

Copy data to tomcat home dir<br/>
`# cp -r /tmp/apache-tomcat-9.0.75/*
/usr/local/tomcat/`

Make tomcat user owner of tomcat home dir<br/>
`# chown -R tomcat.tomcat /usr/local/tomcat`

### Setup systemctl command for tomcat
***
Create tomcat service file<br/>
`# vi /etc/systemd/system/tomcat.service`

Update the file with below content
```
[Unit]
Description=Tomcat
After=network.target
[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i
[Install]
WantedBy=multi-user.target
```

Reload systemd files<br/>
`# systemctl daemon-reload`

Start & Enable service
```
# systemctl start tomcat
# systemctl enable tomcat
```
Enabling the firewall and allowing port 8080 to access the tomcat
```
#systemctl start firewalld

#systemctl enable firewalld

#firewall-cmd --get-active-zones

#firewall-cmd --zone=public --add-port=8080/tcp --permanent

#firewall-cmd --reload
```

### CODE BUILD & DEPLOY (app01)
Download Source code<br/>
`# git clone -b main https://github.com/hkhcoder/vprofile-project.git`

Update configuration
```
# cd vprofile-project
# vim src/main/resources/application.properties
# Update file with backend server details
```

**Build code**<br/>

Run below command inside the repository (vprofile-project)<br/>
`# mvn install`

Deploy artifact
```
# systemctl stop tomcat

# rm -rf /usr/local/tomcat/webapps/ROOT*

# cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# systemctl start tomcat

# chown tomcat.tomcat /usr/local/tomcat/webapps -R

# systemctl restart tomcat
```

## 5. NGINX SETUP
Login to the Nginx vm<br/>
```
$ vagrant ssh web01
$ sudo -i
```
Verify Hosts entry, if entries missing update the it with IP and hostnames<br/>
`# cat /etc/hosts`

Update OS with latest patches<br/>
```
# apt update
# apt upgrade
```

Install nginx<br/>
`# apt install nginx -y`

Create Nginx conf file<br/>
`# vi /etc/nginx/sites-available/vproapp`

Update with below content
```
upstream vproapp {
server app01:8080;
}
server {
listen 80;
location / {
proxy_pass http://vproapp;}
}
```

Remove default nginx conf<br/>
`# rm -rf /etc/nginx/sites-enabled/default`

Create link to activate website<br/>
`# ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp`

Restart Nginx<br/>
`# systemctl restart nginx`