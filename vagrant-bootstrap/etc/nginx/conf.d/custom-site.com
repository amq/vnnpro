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
