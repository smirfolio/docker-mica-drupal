# Configure database
sed s/@db_host@/$MYSQL_PORT_3306_TCP_ADDR/g /opt/mica/data/settings.php | sed s/@db_name@/$MYSQL_DATABASE/g | sed s/@db_pwd@/$MYSQL_ROOT_PASSWORD/g > /app/sites/default/settings.php

mysql -h $MYSQL_PORT_3306_TCP_ADDR -u root --password=$MYSQL_ROOT_PASSWORD -e "drop database if exists $MYSQL_DATABASE; create database $MYSQL_DATABASE;"
mysql -h $MYSQL_PORT_3306_TCP_ADDR -u root --password=$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /opt/mica/data/drupal_mica.sql

# Configure Drupal
cd /app && \
  drush vset -y clean_url 1 && \
  drush dl -y bootstrap && \
  drush en -y bootstrap && \
  drush en -y obiba_bootstrap && \
  drush vset -y theme_default obiba_bootstrap && \
  drush vset -y admin_theme seven && \
  drush en -y obiba_mica && \
  drush dl -y jquery_update && \
  drush en -y jquery_update && \
  drush vset -y jquery_update_jquery_version 1.8 && \
  drush vset -y jquery_update_jquery_admin_version 1.8 && \
  drush vset -y mica_url https://$MICA_PORT_8445_TCP_ADDR:8445 && \
  drush vset -y jquery_update_jquery_version 1.8 && \
  drush vset -y jquery_update_jquery_admin_version 1.8 && \
  drush datatables-download && \
  drush datatables-plugins-download && \
  drush vset -y obiba-progressbar-lib obiba-progressbar-1.0.0 && \
  drush vset -y obiba-progressbar-file "dist/obiba-progressbar" && \
  drush obiba-progressbar-download 1.0.0 && \
  drush en -y obiba_main_app_angular && \
  rm -rf sites/all/libraries/angular-app  && \
  drush angular-app && \
  drush en -y obiba_auth && \
  drush vset -y mica_url https://$AGATE_PORT_8444_TCP_ADDR:8444 && \
  drush en -y obiba_mica_data_access_request

supervisord -n
