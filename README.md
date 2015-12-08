## Vnnpro

A customized ```centos/7``` image created for PHP development. Optimized for performance and low memory usage. Runs multiple PHP versions simultaneously. Supports automatic updates and has a persistent MySQL storage out of the box.

USE WITH CAUTION AND HAVE BACKUPS

VNNPRO IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND

## What's inside

```
CentOS 7 1509.01
Nginx 1.8.0
PHP-FPM 5.5.30
PHP-FPM 7.0.0
HHVM 3.9.0
MariaDB 10.1.9
Redis 2.8.19
MailCatcher 0.6.1
PHP_CodeSniffer 2.4.0
Modman 1.12
```

###### Notable PHP modules

```
curl gd intl mbstring mcrypt memcached mysqlnd opcache pdo pear xdebug zip soap xml
```

## Requirements

```
VirtualBox >= 5.0.10
Vagrant >= 1.7.4
```
```
vagrant-persistent-storage => 0.0.19

vagrant plugin install vagrant-persistent-storage
```

On Windows additionally:
```
vagrant-winnfsd >= 1.0.6

vagrant plugin install vagrant-winnfsd
```

## Getting started

```
git clone https://github.com/amq/vnnpro.git
cd vnnpro
vagrant up
```

SSH:
```
vagrant ssh
```

Reboot:
```
vagrant reload
```

Poweroff:
```
vagrant halt
```

Remove:

*Useful if you need to start from a clean image. Vnnpro has been created to be completely disposable, after ```vagrant up``` you should be back to business in seconds without losing your sites or databases.*
```
vagrant destroy
```

## How to add a site

Vnnpro expects the following directory structure:

```
- vnnpro
    Vagrantfile
    - site.com
        - htdocs
    - example.com
        - htdocs
```

There is no need to create virtual hosts for Nginx. Add a ```site.com``` directory and Vnnpro will automatically respond on:

```
site.com
www.site.com
dev.site.com
vagrant.site.com
hhvm.site.com
php55.site.com
php70.site.com
```

## phpMyAdmin

```
:8001
```
```
root:toor
```

## How to select the PHP engine

##### A) Using subdomains

```
hhvm.site.com
php55.site.com
php70.site.com
```

##### B) Using ports

```
site.com:8000 # hhvm
site.com:8005 # php55
site.com:8007 # php70
```

##### C) Selecting the default engine

Change the following line in Vagrantfile:

<pre>
config.vm.provision :shell, inline: "php-engine.sh <b>hhvm</b>", run: "always" # hhvm, php55, php70
</pre>

Apply changes by restarting Vnnpro:

```
vagrant reload
```

## How to change configuration files

##### A) Over SSH

```
vagrant ssh
sudo su
```

##### B) Adding custom files on host

*This can be useful to make the changes permanent, surviving a ```vagrant destroy``` and image updates.*

Create the following directory structure. Everything contained in ```vagrant-bootstrap/etc``` will be ```rsync```'ed to Vnnpro.

Basically, ```vagrant-bootstrap/etc``` on host maps to ```/etc``` on guest.

```
- vnnpro
    Vagrantfile
    - vagrant-bootstrap
      - etc
```



An example Nginx virtual host:

```
/etc/nginx/conf.d/custom.site.com
```
```
server {
        listen 80;
        listen 443 ssl;

        server_name .custom.site.com;
        root /home/vagrant/sync/custom.site.com/htdocs; # don't forget to change root
        access_log /var/log/nginx/access.log main;

        ssl_certificate /etc/nginx/ssl/own.crt;
        ssl_certificate_key /etc/nginx/ssl/own.key;

        set $php_engine php70; # optional

        include common.conf;
        include try.conf;
        include php.conf;

        # custom rewrites here
        # custom locations here

        # expires $expires;
}
```

An example php.ini:
```
/etc/php.ini
/etc/opt/remi/php70/php.ini
```
```
date.timezone = UTC
display_errors = On
error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE
max_execution_time = 1200
max_input_time = 1200
memory_limit = 512M
upload_max_filesize = 100M
realpath_cache_size = 1024k
realpath_cache_ttl = 600

xdebug.enable = 1
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.idekey = "PHPSTORM"
xdebug.remote_port = 9089
```

## How to build the image from scratch

See the ```build``` branch.