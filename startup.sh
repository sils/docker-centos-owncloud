#!/bin/bash

if [ -z "FIRST_RUN" ]; then
  echo "Container already configured."
else
  # Correct permissions on volumes
  chown -R apache /var/www/html/owncloud/data
  chown -R apache /var/www/html/owncloud/config
  
  # generating owncloud.conf for apache through template
  if [ -z "$OWNCLOUD_URL_PATH" ]; then
    OWNCLOUD_ALIAS=""
  else
    OWNCLOUD_ALIAS="<IfModule mod_alias.c> Alias /$OWNCLOUD_URL_PATH /var/www/html/owncloud </IfModule>"
  sed -e "s#\$OWNCLOUD_ALIAS#$OWNCLOUD_ALIAS#" < /template/owncloud.conf >> /etc/httpd/conf.d/owncloud.conf
  
  # generating autoconfig.php db part through template
  if [ -z "$DB_TYPE" ]; then
    DB_TYPE=sqlite
  fi
  
  case $DB_TYPE in
    sqlite)
      sed -e "s#\$DB_PREFIX#$DB_PREFIX#" < /template/autoconfig_sqlite.php >> /var/www/html/owncloud/config/autoconfig.php
fi

/usr/sbin/httpd -DFOREGROUND -k start
