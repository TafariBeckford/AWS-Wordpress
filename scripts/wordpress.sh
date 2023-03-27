#!/bin/bash 

# Export ENV from parameter store 
DBPassword=$(aws ssm get-parameter --region us-east-1 --name /A4L/Wordpress/DBPassword --with-decryption --query Parameter.Value)
DBPassword=`echo $DBPassword | sed -e 's/^"//' -e 's/"$//'`
DBUser=$(aws ssm get-parameter --region us-east-1 --name /A4L/Wordpress/DBUser --query Parameter.Value)
DBUser=`echo $DBUser | sed -e 's/^"//' -e 's/"$//'`
DBName=$(aws ssm get-parameter --region us-east-1 --name /A4L/Wordpress/DBName --query Parameter.Value)
DBName=`echo $DBName | sed -e 's/^"//' -e 's/"$//'`
DBEndpoint=$(aws ssm get-parameter --region us-east-1 --name /A4L/Wordpress/DBEndpoint --query Parameter.Value)
DBEndpoint=`echo $DBEndpoint | sed -e 's/^"//' -e 's/"$//'`
EFSFSID=$(aws ssm get-parameter --region us-east-1 --name /A4L/Wordpress/EFSFSID --query Parameter.Value)
EFSFSID=`echo $EFSFSID | sed -e 's/^"//' -e 's/"$//'`


sudo yum install -y mysql amazon-efs-utils httpd

sudo echo "CREATE DATABASE IF NOT EXISTS $DBName;" >> /tmp/db.setup
sudo mysql --host=$DBEndpoint -P 3306 --user=$DBUser --password=$DBPassword < /tmp/db.setup
sudo rm /tmp/db.setup

sudo service httpd start
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2


wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

cd wordpress
sudo cp wp-config-sample.php wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sed -i "s/'localhost'/'$DBEndpoint'/g" wp-config.php


cd /home/ec2-user
sudo cp -r wordpress/* /var/www/html/
sudo service httpd restart
 
cd /var/www/html
sudo mv wp-content/ /tmp
sudo mkdir wp-content

echo -e "$EFSFSID:/ /var/www/html/wp-content efs _netdev,tls,iam 0 0"  | sudo tee -a /etc/fstab
sudo mount -a -t efs defaults

sudo cp -R /tmp/wp-content/* /var/www/html/wp-content/
sudo rm -R /tmp/wp-content/
sudo chown -R ec2-user:apache /var/www/
