# Configure database
cd /tmp/mica2-home-master && \
  make import-sql settings db_host=$MYSQL_PORT_3306_TCP_ADDR db_name=$MYSQL_DATABASE db_pass=$MYSQL_ROOT_PASSWORD

# Configure Drupal
cd /tmp/mica2-home-master && \
  make enable-modules setup-dependencies cc && \
  cd /app && \
  drush vset -y mica_url https://$MICA_PORT_8445_TCP_ADDR:8445 && \
  drush vset -y agate_url https://$AGATE_PORT_8444_TCP_ADDR:8444

supervisord -n
