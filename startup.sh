#!/bin/bash

chown -R apache /var/www/html/owncloud
/usr/sbin/httpd -DFOREGROUND
