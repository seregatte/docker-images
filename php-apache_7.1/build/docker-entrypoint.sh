#!/bin/bash

xdebug_enable()
{
	echo "Enabling xdebug..."
	echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	echo 'xdebug.remote_connect_back=1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	echo 'xdebug.max_nesting_level=256' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	docker-php-ext-enable xdebug
}

# Enable xdebug
[[ "$XDEBUG_ENABLED" != "" ]] && [[ "$XDEBUG_ENABLED" != "0" ]] && xdebug_enable

sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
sed -ri -e 's!AllowOverride None!AllowOverride All!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
a2enmod rewrite

echo "Welcome to seregatte's PHP stack"
exec "$@"