#!/bin/bash

cd /home/vagrant/sync/vagrant-bootstrap

## Skip if already provisioned (for a faster first boot)

if [ -f /etc/vagrant.provisioned ]; then
    exit 0
fi

## Disable SELinux

sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

## Fix home permissions

chmod +x /home/vagrant

## Update system and install essential packages

yum -y update
yum -y install epel-release git wget rsync unzip nano

## Copy yum repos
## Keep permissions as 755 (directories), 644 (files)

if [ -d etc/yum.repos.d ]; then
    chown -R root:root etc/
    rsync -a --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r etc/yum.repos.d/ /etc/yum.repos.d
else
    echo '"vagrant-bootstrap/etc/yum.repos.d" directory is missing, cannot install packages'
    exit 1
fi

## Nginx

yum -y install nginx

rm /etc/nginx/conf.d/default.conf
rm /etc/nginx/conf.d/example_ssl.conf

mkdir /etc/nginx/ssl
openssl req -new -x509 -nodes -days 3560 -out /etc/nginx/ssl/own.crt -keyout /etc/nginx/ssl/own.key -subj "/C=US/ST=New York"

## PHP-FPM 5.5

yum -y install composer php-cli php-curl php-fpm php-gd php-intl php-mbstring php-mcrypt php-memcached php-mysqlnd php-opcache php-pdo php-pear php-pecl-xdebug php-pecl-zip php-soap php-xml

## PHP-FPM 7.0

yum -y install php70-php-cli php70-php-curl php70-php-fpm php70-php-gd php70-php-intl php70-php-mbstring php70-php-mcrypt php70-php-memcached php70-php-mysqlnd php70-php-opcache php70-php-pdo php70-php-pear php70-php-pear php70-php-pecl-xdebug php70-php-pecl-zip php70-php-soap php70-php-xml

## HHVM

yum -y install hhvm

mkdir /var/log/hhvm
mkdir /var/run/hhvm

## MariaDB

yum -y install MariaDB-server MariaDB-client phpmyadmin
mkdir /var/log/mariadb
chown mysql:mysql /var/log/mariadb

systemctl start mariadb
mysqladmin -u root password toor > /dev/null 2>&1
systemctl stop mariadb

rsync -a /var/lib/mysql/ /var/lib/mysql_bak

## Redis

yum -y install redis

## MailCatcher

yum -y install gcc gcc-c++ sqlite-devel ruby-devel
gem install mailcatcher

## PHP_CodeSniffer

pear install PHP_CodeSniffer

## Modman

wget -NP /usr/local/bin https://raw.githubusercontent.com/colinmollenhour/modman/master/modman
chmod +x /usr/local/bin/modman

## Add PHP engine switcher script

\cp php-engine.sh /usr/local/bin/php-engine.sh
chmod +x /usr/local/bin/php-engine.sh

## Add startup script

\cp vnnpro-startup.sh /usr/local/bin/vnnpro-startup.sh
chmod +x /usr/local/bin/vnnpro-startup.sh

## Add /usr/local/bin to $PATH for root

echo 'PATH=$PATH:/usr/local/bin' >> ~/.bashrc

## Cleanup

yum clean all

touch /etc/vagrant.provisioned
