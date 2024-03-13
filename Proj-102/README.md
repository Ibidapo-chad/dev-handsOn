# AWS Lift & Shift

## Prerequisites
#
- JDK 1.8 or later
- Maven 3 or later
- MySQL 5.6 or later
- AWS account

## Services
- AWS EC2
- Elastic Load balancer (ELB)
- S3 Bucket  
- Route 53
- AWS certificate Manager
- Maven
- Tomcat
- MySQL
- Memcached
- Rabbitmq
- Elastic cache

## Database
Here,we used Mysql DB 
MSQL DB Installation Steps for Linux ubuntu 14.04:
- $ sudo apt-get update
- $ sudo apt-get install mysql-server

Then look for the file:<br>
`/src/main/resources/accountsdb`  
`accountsdb.sql file is a mysql dump file.we have to import this dump to mysql db server`  
`mysql -u <user_name> -p accounts < accountsdb.sql`

## System Architecture
[](./aws_lift_%26_shift.drawio.svg)

