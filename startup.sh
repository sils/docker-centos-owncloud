#!/bin/bash

if [ -e /var/www/html/owncloud/INSTALLED ]; then
  echo "Container already configured. Performing ownCloud update/upgrade."
  cd /var/www/html/owncloud
  su apache -c php occ upgrade
else
  echo "Setting up container."
  
  echo "Generating apc.ini for php through template."
  if [ -z "$PHP_APC_SIZE" ]; then
    PHP_APC_SIZE="512M"
  fi
  sed -e "s#\$PHP_APC_SIZE#$PHP_APC_SIZE#" < /template/apc.ini > /etc/php.d/apc.ini
  
  echo "Generating SSL self-signed certificate."
  if [ -z "$FQDN" ]; then
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
  if [ -z "$SSL_ORGANISATION_UNIT" ]; then
    SSL_ORGANISATION_UNIT="IT"
  fi
  
  openssl req -nodes -x509 -newkey rsa:4096 -keyout /etc/pki/tls/private/localhost.key -out /etc/pki/tls/certs/localhost.crt -days 1825 -subj "/CN=$FQDN/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANISATION/OU=$SSL_ORGANISATION_UNIT"
  
  echo "Removing apache welcome page config."
  rm -f /etc/httpd/conf.d/welcome.conf
  
  echo "Generating owncloud.conf for apache through template."
  sed -e "s#\$OWNCLOUD_ALIAS#$OWNCLOUD_ALIAS#" < /template/owncloud.conf > /etc/httpd/conf.d/owncloud.conf
  
  echo "Copying autoconfig.php from template folder."
  cp /template/autoconfig.php /var/www/html/owncloud/config/autoconfig.php
  
  echo "Correcting permissions on volumes."
  chown -R apache:apache /var/www/html/owncloud
  
  touch /var/www/html/owncloud/INSTALLED
  echo "Configuration finished!"
fi

/usr/sbin/httpd -DFOREGROUND -k start
