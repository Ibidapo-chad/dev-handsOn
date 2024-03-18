# Project 103 - Refactoring

## About this project

From previous project, we deployed our application stack using a lift and shift strategy.

This project is about re-architecting or refactoring our services on AWS cloud to build a multi-tier application. This approach is used to boost agility or to improve business continuity. This is so we can add new features, scale effectively and easily and have very good performance for our application workload.

For this project we would be making use of PAAS (Platform as a Service) / SAAS (Software as a service) instead of IAAS (Infrasture as a Service).

## Solution

The cloud Setup would combine PAAS/SAAS and IAAC AWS cloud infrastructure computing models to build a flexible infrasture with low operational overhead.

| AWS Services | Use scenario
--- | ---
Elastic Beanstalk | Host our VM for Tomcat (app server)
|  | Provision a Load Balancer as replacement for Nginx
|  | Automation for VM auto scaling
S3 / EFS  | Storing artifacts
RDS Instance | For Database
Elastic Cache | Used instead of MemcacheD
Active MQ | Used instead of Rabbit MQ
Route 53 | For DNS
CloudFront | For content delivery network

## Prerequisites
- JDK 1.8 or later
- Maven 3 or later
- MySQL 5.6 or later
- AWS account


## Database
Here,we used Amazon RDS Mysql DB 

Look for the file :
- /src/main/resources/accountsdb
- accountsdb.sql file is a mysql dump file.we have to import this dump to mysql db server
- > mysql -u <user_name> -p accounts < accountsdb.sql


## Architecture of AWS services for Project
![Application Design](./refactor-arch-design.svg)
