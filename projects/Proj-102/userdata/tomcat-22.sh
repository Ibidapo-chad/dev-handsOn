#!/bin/bash 

sudo -i

apt update -y
apt install openjdk-11-jdk -y

#create tomcat user and group with a home directory of /opt/tomcat to run the Tomcat service 
useradd -m -U -d /opt/tomcat -s /bin/false tomcat 

#change directory to /tmp to download the tomcat package into 
cd /tmp 

#download tomcat 
VERSION=9.0.86 
wget https://downloads.apache.org/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz 


#extract the tar file to /opt/tomcat directory 
tar -xf /tmp/apache-tomcat-${VERSION}.tar.gz -C /opt/tomcat/ 


#create a symbolic link called “latest” that points to the Tomcat installation directory for more control of updates 
ln -s /opt/tomcat/apache-tomcat-${VERSION} /opt/tomcat/latest 
 

#change the directory ownership to the user and group tomcat 
chown -R tomcat: /opt/tomcat 
 

#change the shell scripts permission in the bin directory to executable 
sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh' 
 
rm -rf /etc/systemd/system/tomcat.service

#create the systemD Unit file 
cat <<EOT>> /etc/systemd/system/tomcat.service
[Unit] 
Description=Tomcat 9 servlet container 
After=network.target

[Service] 
Type=forking 
User=tomcat 
Group=tomcat 

Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" 
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true" 

Environment="CATALINA_BASE=/opt/tomcat/latest" 
Environment="CATALINA_HOME=/opt/tomcat/latest" 
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid" 
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC" 
ExecStart=/opt/tomcat/latest/bin/startup.sh 
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install] 
WantedBy=multi-user.target 
EOT

#save and close the file. Notify systemd that a new file exists 
systemctl daemon-reload
systemctl enable --now tomcat
systemctl status tomcat
