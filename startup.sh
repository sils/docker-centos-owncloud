#!/bin/bash

# Correct permissions on volumes
chown -R apache /var/www/html/owncloud/data
chown -R apache /var/www/html/owncloud/config

/usr/sbin/httpd -DFOREGROUND -k start
