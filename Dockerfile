FROM sils1297/centos-webserv
MAINTAINER Lasse Schuirmann lasse.schuirmann@gmail.com

RUN echo SELINUX=disabled >> /etc/selinux/config
RUN cd /etc/yum.repos.d/ && wget http://download.opensuse.org/repositories/isv:ownCloud:community/CentOS_CentOS-7/isv:ownCloud:community.repo && yum install owncloud -y

EXPOSE 80 8080

RUN echo "chown -R apache /var/www/html/owncloud" >> /etc/startup.sh
RUN echo "/usr/sbin/httpd -DFOREGROUND" >> /etc/startup.sh

CMD /etc/startup.sh
