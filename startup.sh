#!/bin/bash

chown -R apache /var/www/html/owncloud/data
/usr/sbin/httpd -DFOREGROUND -k start
