Project 101 setup

This is project defines a manual setup of VMs running separately different services.

Scope:
VM Setup
Provisioning
Project-101 web architecture design
Code Build and Deploy

Prerequisite
1. Oracle VM Virtualbox
2. Vagrant
3. Vagrant plugins
Execute below command in your computer to install hostmanager plugin
$ vagrant plugin install vagrant-hostmanager
4. Git bash or equivalent editor

VM Setup
1. Clone source code.
2. Cd into the repository.
3. Switch to the main branch.
4. cd into vagrant/ Manual_provisioning

Provisioning
    Services
1. Nginx            =>  Web Service
2. Tomcat           =>  Application Server
3. RabbitMQ         =>  Broker/Queuing Agent
4. Memcache         =>  DB Caching
5. ElasticSearch    =>  Indexing/Search service
6. MySQL            =>  SQL Database







