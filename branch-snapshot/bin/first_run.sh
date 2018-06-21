#!/bin/bash

# Configure database
if [ -n $MYSQL_PORT_3306_TCP_ADDR ]
	then
	# Wait for MySQL to be ready
	until mysql -h $MYSQL_PORT_3306_TCP_ADDR -u root -p$MYSQL_ROOT_PASSWORD -e ";" &> /dev/null
	do
	  sleep 1
	done

	cd /tmp/obiba-home-master && \
	  make import-sql-tables settings db_host=$MYSQL_PORT_3306_TCP_ADDR db_name=$MYSQL_DATABASE db_pass=$MYSQL_ROOT_PASSWORD drupal_dir=/var/www/html
fi

# Drupal settings
if [ ! -z $BASE_URL ]
	then
	echo '$base_url = "'$BASE_URL'";' >> /var/www/html/sites/default/settings.php
fi

# Remove memory limit to prevent drush memory error
echo "ini_set('memory_limit', '-1');" >> /var/www/html/sites/default/settings.php

# Configure Drupal (requires database connection)
cd /tmp/obiba-home-master && \
	make enable-modules-snapshot drupal_dir=/var/www/html mica_js_dependencies_branch=${MICA_JS_VERSION}

if [ -n $MICA_PORT_8445_TCP_ADDR ]
	then
	cd /var/www/html && \
	  drush vset -y mica_url https://$MICA_PORT_8445_TCP_ADDR:8445
fi

if [ -n $AGATE_PORT_8444_TCP_ADDR ]
	then
	cd /var/www/html && \
	  drush vset -y agate_url https://$AGATE_PORT_8444_TCP_ADDR:8444
fi

cd /var/www/html && \
  drush upwd administrator --password=$DRUPAL_ADMINISTRATOR_PASSWORD && \
  drush vset -y mica_anonymous_password $MICA_ANONYMOUS_PASSWORD && \
  chown -R www-data:www-data .
