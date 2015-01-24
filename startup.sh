#!/bin/bash

if [ -z "FIRST_RUN" ]; then
  echo "Container already configured."
else
  echo "Setting up container."
  
  echo "Correcting permissions on volumes."
  chown -R apache /var/www/html/owncloud/data
  chown -R apache /var/www/html/owncloud/config
  
  echo "Generating owncloud.conf for apache through template."
  if [ -z "$OWNCLOUD_URL_PATH" ]; then
    OWNCLOUD_ALIAS=""
  else
    OWNCLOUD_ALIAS="<IfModule mod_alias.c> Alias /$OWNCLOUD_URL_PATH /var/www/html/owncloud </IfModule>"
  sed -e "s#\$OWNCLOUD_ALIAS#$OWNCLOUD_ALIAS#" < /template/owncloud.conf >> /etc/httpd/conf.d/owncloud.conf
  
  echo "Generating autoconfig.php db part through template."
  if [ -z "$DB_TYPE" ]; then
    DB_TYPE="sqlite"
  fi
  
  echo "Using db backend $DB_TYPE."
  case $DB_TYPE in
    sqlite)
      sed -e "s#\$DB_PREFIX#$DB_PREFIX#" < /template/autoconfig_sqlite.php >> /var/www/html/owncloud/config/autoconfig.php
fi

/usr/sbin/httpd -DFOREGROUND -k start
