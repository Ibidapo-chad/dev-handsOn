# Project 101 setup

This is project defines a manual setup of VMs running separate different services.

## Scope:
VM Setup
Provisioning
Project-101 web architecture design
Code Build and Deploy

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
> [!NOTE]
> Bringing up all the vm’s may take a long time based on various factors.
If vm setup stops in the middle run “vagrant up” command again.

SYSTEM DESIGN DIAGRAM
___

![Web Design Architecture](./SysDesignDiag.drawio)

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


Login to the db vm
<br/>`$ vagrant ssh db01`

Verify Hosts entry, if entries missing update the it with IP and hostnames

`# cat /etc/hosts`

Update OS with latest patches

`# yum update -y`

Set Repository

`# yum install epel-release -y`

Install Maria DB Package
`# yum install git mariadb-server -y`

Starting & enabling mariadb-server

```
# systemctl start mariadb
# systemctl enable mariadb
```

> [!NOTE]
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