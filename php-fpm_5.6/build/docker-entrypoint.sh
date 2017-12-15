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

echo "Welcome to seregatte's PHP stack"
exec "$@"