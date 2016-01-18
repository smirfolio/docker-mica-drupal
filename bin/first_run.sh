#!/bin/bash

# Wait for MySQL to be ready
until mysql -h $MYSQL_PORT_3306_TCP_ADDR -u root -p$MYSQL_ROOT_PASSWORD -e ";" &> /dev/null
do
  sleep 1
done

# Configure database
cd /tmp/mica2-home-master && \
  make import-sql-tables settings db_host=$MYSQL_PORT_3306_TCP_ADDR db_name=$MYSQL_DATABASE db_pass=$MYSQL_ROOT_PASSWORD drupal_dir=/var/www/html

# Configure Drupal
cd /tmp/mica2-home-master && \
  make enable-modules-snapshot drupal_dir=/var/www/html

cd /var/www/html && \
  drush vset -y mica_url https://$MICA_PORT_8445_TCP_ADDR:8445 && \
  drush vset -y agate_url https://$AGATE_PORT_8444_TCP_ADDR:8444 && \
  drush upwd administrator --password=$DRUPAL_ADMINISTRATOR_PASSWORD && \
  drush vset -y mica_anonymous_password $MICA_ANONYMOUS_PASSWORD && \
  chown -R www-data:www-data .
