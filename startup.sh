#!/bin/bash

if [ -e /INSTALLED ]; then
  echo "Container already configured."
else
  echo "Setting up container."
  
  echo "Generating apc.ini for php through template."
  if [ -z "$PHP_APC_SIZE" ]; then
    PHP_APC_SIZE="512M"
  fi
  sed -e "s#\$PHP_APC_SIZE#$PHP_APC_SIZE#" < /template/apc.ini > /etc/php.d/apc.ini
  
  echo "Generating SSL self-signed certificate."
  if [ -r "$FQDN" ]; then
    FQDN="example.com"
  fi
  if [ -z "$SSL_COUNTRY" ]; then
    SSL_COUNTRY="US"
  fi
  if [ -z "$SSL_STATE" ]; then
    SSL_STATE="New York"
  fi
  if [ -z "$SSL_LOCALITY" ]; then
    SSL_LOCALITY="Brooklyn"
  fi
  if [ -z "$SSL_ORGANISATION" ]; then
    SSL_ORGANISATION="Example Brooklyn Company"
  fi
  openssl req -newkey rsa:2048 -nodes -keyout /etc/httpd/server.key -x509 -days 1825 -out /etc/httpd/server.csr -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANISATION/CN=$FQDN"
  
  echo "Generating owncloud.conf for apache through template."
  sed -e "s#\$FQDN#$FQDN#" < /template/owncloud.conf > /etc/httpd/conf.d/owncloud.conf
  
  echo "Generating autoconfig.php db part through template."
  if [ -z "$MYSQL_NAME" ]; then
    echo "No linked mysql container detected."
  else
    echo "Linked mysql container detected with id $HOSTNAME and version $MYSQL_ENV_MYSQL_VERSION."
    DB_TYPE="linked_mysql"
  fi
  
  if [ -z "$DB_TYPE" ]; then
    DB_TYPE="sqlite"
  fi
  
  if [ -z "$DB_PREFIX" ]; then
    DB_PREFIX="oc_"
  fi
  
  echo "Using db backend $DB_TYPE."
  case $DB_TYPE in
    sqlite)
      sed -e "s#\$DB_PREFIX#$DB_PREFIX#" < /template/autoconfig_sqlite.php > /var/www/html/owncloud/config/autoconfig.php
      ;;

    linked_mysql)
      if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        echo "MYSQL_ROOT_PASSWORD was not given! Configuration aborted!"
        exit 1
      fi
      MYSQL_HOST=`echo $MYSQL_NAME | /bin/awk -F "/" '{print $3}'`
      sed -e "s#\$MYSQL_ROOT_PASSWORD#$MYSQL_ROOT_PASSWORD#" < /template/autoconfig_mysql.php > /var/www/html/owncloud/config/autoconfig.php
      sed -i '' -e "s#\$MYSQL_HOST#$MYSQL_HOST#" /var/www/html/owncloud/config/autoconfig.php
      sed -i '' -e "s#\$DB_PREFIX#$DB_PREFIX#" /var/www/html/owncloud/config/autoconfig.php
  esac
  
  echo "Finishing generation of autoconfig.php with footer."
  cat /template/autoconfig_footer.php >> /var/www/html/owncloud/config/autoconfig.php
  
  echo "Correcting permissions on volumes."
  chown -R apache /var/www/html/owncloud
  chown -R apache /etc/httpd
  chown -R apache /etc/php.d
  
  touch /INSTALLED
fi

/usr/sbin/httpd -DFOREGROUND -k start
