FROM centos:centos7
MAINTAINER Christian Witt c.witt.1900@gmail.com

RUN echo SELINUX=disabled >> /etc/selinux/config
RUN yum update -y && \
    yum install wget -y && \
    cd /etc/yum.repos.d/ && \
    wget http://download.opensuse.org/repositories/isv:ownCloud:community/CentOS_CentOS-7/isv:ownCloud:community.repo && \
    yum install httpd httpd-devel php php-dom php-pear php-mysql php-gd php-mbstring php-pspell php-pdo php-xml php-devel sqlite pcre-devel gcc make openssl mod_ssl -y && \
    yum install owncloud -y && \
    yum clean all

RUN pecl install apc

RUN mkdir -p /template
ADD template/* /template/

EXPOSE 80 80
EXPOSE 443 443

VOLUME /var/www/html/owncloud /etc/pki/tls/private /etc/pki/tls/certs /etc/httpd/conf.d /etc/php.d

ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD /startup.sh
