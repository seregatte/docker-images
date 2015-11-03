FROM blalor/centos

MAINTAINER João Paulo Seregatte Costa <joaopaulo@fisqua.com>
RUN yum -y install php php-devel php-gd php-imap php-mysql php-odbc \
	php-pear php-xml php-xmlrpc php-pecl-apc php-mbstring php-mcrypt \
	php-snmp php-soap php-tidy curl curl-devel ImageMagick libxml2 \
	libxml2-devel php-cli sendmail httpd-devel mysql-server vim wget monit

COPY conf/monit/httpd /etc/monit.d/httpd
COPY conf/monit/mysqld /etc/monit.d/mysqld

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN composer global require drush/drush:6.*

RUN composer global require drupal/drupal-extension:~3.0

RUN echo "date.timezone=America/Sao_Paulo" >> /etc/php.ini 

WORKDIR /var/www/html

ENV PATH /.composer/vendor/bin:$PATH

EXPOSE 80 3306
VOLUME ["/var/www/html"]

RUN sed -i -- 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf

ADD conf/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD /usr/bin/monit -l - -v -d 10 -Ic /etc/monit.conf