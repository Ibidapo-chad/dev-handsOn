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


