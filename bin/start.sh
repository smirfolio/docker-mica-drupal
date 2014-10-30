# Configure database
sed s/@db_host@/$MYSQL_PORT_3306_TCP_ADDR/g /opt/mica/data/settings.php | sed s/@db_name@/$MYSQL_DATABASE/g | sed s/@db_pwd@/$MYSQL_ROOT_PASSWORD/g > /app/sites/default/settings.php

mysql -h $MYSQL_PORT_3306_TCP_ADDR -u root --password=$MYSQL_ROOT_PASSWORD -e "drop database if exists $MYSQL_DATABASE; create database $MYSQL_DATABASE;"
mysql -h $MYSQL_PORT_3306_TCP_ADDR -u root --password=$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /opt/mica/data/drupal-7.31.sql

# Configure Drupal
cd /app && \
  drush dl -y bootstrap && \
  drush en -y bootstrap && \
  drush en -y micado_bootstrap && \
  drush vset -y theme_default micado_bootstrap && \
  drush vset -y admin_theme seven && \
  drush en -y mica_client && \
  drush en -y obiba_auth && \
  drush dl -y jquery_update && \
  drush en -y jquery_update && \
  drush vset -y mica_url https://$MICA_PORT_8445_TCP_ADDR:8445 && \
  drush vset -y jquery_update_jquery_version 1.8 && \
  drush vset -y jquery_update_jquery_admin_version 1.8

supervisord -n