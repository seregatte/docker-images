#!/bin/bash
set -e

function _ChangeUidGid(){
	local _user=$1
	local _dev_uid=$2
	local _group=$3
	local _dev_gid=$4
	local _orig_uid=$(cat /etc/passwd | grep $_user | cut -f3 -d:)
	local _orig_gid=$(cat /etc/passwd | grep $_user | cut -f4 -d:)
	local _orig_home=$(cat /etc/passwd | grep $_user | cut -f6 -d:)
	if ! grep -q $_dev_gid /etc/group && ! grep -q $_group /etc/group ; then
		groupadd $_group -g $_dev_gid
	else 
		if grep -q $_dev_gid /etc/group && ! grep -q $_group /etc/group ; then
			local _rep_grp_name=$(cat /etc/group | grep :$DEV_GID: | cut -f1 -d:)
			groupmod -n $_group $_rep_grp_name
		fi
	fi
	sed -i -e "s/:$_orig_uid:/:$_dev_uid:/" /etc/passwd
	usermod -a -G $_group $_user || true
	test -d "$_orig_home" && chmod 6755 -Rf $_orig_home || chown -Rf $_dev_uid.$_dev_gid $_orig_home
	return $?
}

if [ "$3" = '/usr/bin/monit -l - -v -d 10 -Ic /etc/monit.conf' ]; then
	echo "Provisionando..."
	if ! grep -q $DRUPAL_DIRECTORY "/etc/httpd/conf/httpd.conf" ; then
		echo "Mudando diretorio apache:" $DRUPAL_DIRECTORY
		test $DRUPAL_DIRECTORY && mkdir -p $DRUPAL_DIRECTORY
		test $DRUPAL_DIRECTORY && sed -i -- 's%/var/www/html%'$(echo $DRUPAL_DIRECTORY)'%g' /etc/httpd/conf/httpd.conf
	fi
	if [ "$MAILCATCHER" = 1 ]; then
		echo "Integrando com o mailcatcher"
		sed -i -- 's/SMTP = localhost/SMTP = mailcatcher/g' /etc/php.ini
		sed -i -- 's/smtp_port = 25/smtp_port = 1025/g' /etc/php.ini
	fi
	test $DEV_UID && test $DEV_GID && _ChangeUidGid "apache" $DEV_UID "developers" $DEV_GID
	/etc/init.d/mysqld start
	if ! mysql -u root --database drupal -e 'show tables;' ; then
		echo "Criando database Drupal."
		mysql -u root -e 'CREATE DATABASE drupal;'
	fi
fi

echo "Welcome to a LAMP Stack in centOS 6.5"
echo "Mailcatcher:" $MAILCATCHER
echo "Drupal Directory:" $DRUPAL_DIRECTORY
echo "Dev UID:" $DEV_UID
echo "Dev GID:" $DEV_GID
echo "Command:" $1 / $2 / $3 / $4 / $5

exec "$@"