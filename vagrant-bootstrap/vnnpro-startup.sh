#!/bin/bash

## Copy config files from host
## Keep permissions as 755 (directories), 644 (files)
if [ -d /home/vagrant/sync/vagrant-bootstrap/etc ]; then
    cd /home/vagrant/sync/vagrant-bootstrap
    chown -R root:root etc/
    rsync -a --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r etc/ /etc
fi

## Needed for the vagrant-persistent-storage mount
chown mysql:mysql /var/lib/mysql

## MariaDB won't start on an empty mount
if ! [ -d /var/lib/mysql/mysql ]; then
    rsync -a /var/lib/mysql_bak/ /var/lib/mysql
fi

## We don't use "systemctl enable"
## to make sure we load the new configuration
systemctl restart nginx
systemctl restart hhvm
systemctl restart php-fpm
systemctl restart php70-php-fpm
systemctl restart mariadb
systemctl restart redis

mailcatcher > /dev/null 2>&1

IP=$(hostname -I | cut -d ' ' -f 2)

cat <<EOF

=======================================================
=======================================================

 _    _ __   _ __   _  _____   ______  _____
  \  /  | \  | | \  | |_____] |_____/ |     |
   \/   |  \_| |  \_| |       |    \_ |_____|


IP: $IP
phpMyAdmin: $IP:8001

To add site.com create a directory 'site.com/htdocs'

Don't forget do add a record your local hosts file:
$IP site.com
$IP www.site.com

For more details see https://github.com/amq/vnnpro


=======================================================
=======================================================

EOF

exit 0
