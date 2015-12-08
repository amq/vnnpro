#!/bin/bash

ENGINE="${1}"

case "$1" in
    hhvm)
        ENGINE="hhvm"
        ;;
    php55)
        ENGINE="php55"
        ;;
    php70)
        ENGINE="php70"
        ;;
    *)
        ENGINE="hhvm"
esac

sed -i "s/default.*# change/default     $ENGINE; # change/g" /etc/nginx/nginx.conf