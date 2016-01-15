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
  make enable-modules-release drupal_dir=/var/www/html

cd /var/www/html && \
  drush vset -y mica_url https://$MICA_PORT_8445_TCP_ADDR:8445 && \
  drush vset -y agate_url https://$AGATE_PORT_8444_TCP_ADDR:8444 && \
  drush upwd administrator --password=$DRUPAL_ADMINISTRATOR_PASSWORD && \
  drush vset -y mica_anonymous_password $MICA_ANONYMOUS_PASSWORD && \
  drush en -y obiba_mica_graphic && \
  php -r "print json_encode(array('NaN'=>'NaN'));"  | drush vset --format=json graphics_blocks_networks - &&\
  php -r "print json_encode(array('populations-selectionCriteria-countriesIso'=>'populations-selectionCriteria-countriesIso', 'populations-recruitment-dataSources'=>'populations-recruitment-dataSources', 'methods-designs'=>'methods-designs', 'populations-dataCollectionEvents-bioSamples'=>'populations-dataCollectionEvents-bioSamples','access'=>'access'));"  | drush vset --format=json graphics_blocks_aggregations - && \
  drush vset -y countriesIso_css  col-md-6
  drush vset -y recruitment-dataSources_css  col-md-6
  drush vset -y methods-designs_css  col-md-6
  drush vset -y populationDceBioSamples_css  col-md-6
  drush vset -y access_css  col-md-6
  echo "\$base_url = 'https://nightly.obiba.org';" >> sites/default/settings.php && \
  chown -R www-data:www-data .
