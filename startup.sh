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
  sed -e "s#\$OWNCLOUD_ALIAS#$OWNCLOUD_ALIAS#" < /template/owncloud.conf > /etc/httpd/conf.d/owncloud.conf
  
  echo "Generating autoconfig.php db part through template."
  if [ -z "$MYSQL_ENV_MYSQL_ROOT_PASSWORD" ]; then
    echo "No linked mysql container detected."
  else
    echo "Linked mysql container detected with id $HOSTNAME and version $MYSQL_ENV_MYSQL_VERSION."
    DB_TYPE="linked_mysql"
  fi
  
  if [ -z "$DB_TYPE" ]; then
    DB_TYPE="sqlite"
  fi
  
  echo "Using db backend $DB_TYPE."
  case $DB_TYPE in
    sqlite)
      sed -e "s#\$DB_PREFIX#$DB_PREFIX#" < /template/autoconfig_sqlite.php > /var/www/html/owncloud/config/autoconfig.php
      ;;

    linked_mysql)
      MYSQL_HOST=`echo $MYSQL_NAME | /bin/awk -F "/" '{print $3}'`
      sed -e "s#\$MYSQL_ENV_MYSQL_ROOT_PASSWORD#$MYSQL_ENV_MYSQL_ROOT_PASSWORD#" < /template/autoconfig_mysql.php > /var/www/html/owncloud/config/autoconfig.php
      sed -i '' -e "s#\$MYSQL_HOST#$MYSQL_HOST#" /var/www/html/owncloud/config/autoconfig.php
      sed -i '' -e "s#\$DB_PREFIX#$DB_PREFIX#" /var/www/html/owncloud/config/autoconfig.php
    esac
fi

/usr/sbin/httpd -DFOREGROUND -k start
