FROM centos:7
MAINTAINER Natchapon Futragoon <natchapon.f@gmail.com>


RUN yum -y install wget
RUN yum -y install git
RUN yum -y install curl 

RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm

#RUN rpm -Uvh remi-release-7*.rpm

#RUN yum-config-manager --enable remi-php70

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
#RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm

RUN yum -y install httpd
COPY app.conf /etc/httpd/conf.d/app.conf
RUN mkdir -p /var/www/api/public
RUN mkdir -p /var/www/control/public

COPY mongodb-org-3.2.repo /etc/yum.repos.d/mongodb-org-3.2.repo

RUN mkdir -p /data/db

RUN yum -y install nodejs
RUN yum -y install mongodb-org

RUN \
	yum -y install \
		php70w \
		php70w-common \
		php70w-mbstring \
		php-mcrypt \
		php70w-devel \
		php-xml \
		php-mysqlnd \
		php70w-pdo \
		php70w-opcache --nogpgcheck \

		`# install the following PECL packages:` \
		php-pecl-memcached \
		php-pecl-mysql \
		php-pecl-xdebug \
		php-pecl-zip \
		php-pecl-amqp --nogpgcheck \
		php-pecl-mongodb \

		`# Temporary workaround: one dependant package fails to install when building image (and the yum error is: Error unpacking rpm package httpd-2.4.6-40.el7.centos.x86_64` \
		|| true


RUN yum -y install mlocate git-all unzip
RUN yum -y install openssh-server supervisor
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf

#RUN curl -sS https://getcomposer.org/installer | php
#RUN mv composer.phar /usr/local/bin/composer

EXPOSE 22 80 443 27017

#install
WORKDIR /var/www/

#CMD ["/usr/bin/supervisord"]
CMD ["/usr/sbin/apachectl -D FOREGROUND"]

