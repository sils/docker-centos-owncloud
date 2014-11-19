Owncloud on CentOS
==================

This docker image provides an owncloud server based on CentOS.

How to Execute
==============

The following command will run an owncloud server. Feel free to change ports
according to your needs. It will store the data in
/your/directory/for/owncloud/data. Consider changing that too ;).

```docker run --name="owncloud"    -d --restart=always -p 80:80 -p 8080:8080 \
-v /your/directory/for/owncloud/data:/var/www/html/owncloud/data sils1297/centos-owncloud```

License
=======

Everything published in this repository is GNU GPL 3.
