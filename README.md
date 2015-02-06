# Supported tags and respective `Dockerfile` links
- [`latest`](https://github.com/cw1/docker-centos-owncloud/blob/master/Dockerfile)
- [`testing`](https://github.com/cw1/docker-centos-owncloud/blob/testing/Dockerfile)

# What is ownCloud?

ownCloud is a software system for what is commonly termed "file hosting". As such, ownCloud is very similar to the widely used Dropbox, with the primary difference being that ownCloud is free and open-source, and thereby allowing anyone to install and operate it without charge on a private server, with no limits on storage space (except for hard disk quota or capacity) or the number of connected clients.

> [wikipedia.org/wiki/ownCloud](http://en.wikipedia.org/wiki/Owncloud)

![logo](http://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/OwnCloud2-Logo.svg/200px-OwnCloud2-Logo.svg.png)

# How to use this image

## Start a owncloud instance

  docker run --name some-owncloud -d cw1900/docker-centos-owncloud

This image contains `EXPOSE 80` and `EXPOSE 443`, so that ownCloud is available immediately after starting. By default this image creates a self-signed certificate to enable https connection and forces ownCloud to use it.

## Environment Variables

You can use the following variables to costumize your ownCloud container:

### `PHP_APC_SIZE`

As this image uses php-apc to ensure best practical performance of ownCloud, you can costumize the size witch is used by php-apc. If not set, `PHP_APC_SIZE` is set to `512M`.

### `FQDN`

As you might suggest, you can set your fully qualified domain name in this variable. If not set, `FQDN` is set to `example.com`.

### `SSL_COUNTRY`

With this variable you can set your country which is set into the self-signed certificate. If not set, `SSL_COUNTRY` is set to `US`.

### `SSL_STATE`

Same as `SSL_COUNTRY` but for your state. If not set, `SSL_STATE` is set to `New York`.

### `SSL_LOCALITY`

Same as `SSL_COUNTRY` but for your locality. If not set, `SSL_LOCALITY` is set to `Brooklyn`.

### `SSL_ORGANISATION`

Same as `SSL_COUNTRY` but for your organisation name. If not set, `SSL_ORGANISATION` is set to `Example Brooklyn Company`.

### `SSL_ORGANISATION_UNIT`

Same as `SSL_COUNTRY` but for your organisation unit. If not set, `SSL_ORGANISATION_UNIT` is set to `IT`.

### `OWNCLOUD_ALIAS`

Using this variable to set the apache alias for owncloud. If not set, `OWNCLOUD_ALIAS` is empty.

## Example

`docker run --name some-owncloud -e PHP_APC_SIZE="512M" -e FQDN="example.com" -e SSL_COUNTRY="US" -e SSL_STATE="New York" -e SSL_LOCALITY="Brooklyn" -e SSL_ORGANISATION="Example Brooklyn Company" -e SSL_ORGANISATION_UNIT="IT" -e OWNCLOUD_ALIAS="owncloud" -d cw1900/docker-centos-owncloud`