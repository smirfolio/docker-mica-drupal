#
# Mica Drupal client Dockerfile
#
# https://github.com/obiba/docker-mica-drupal
#

# Pull base image
FROM centurylink/apache-php:latest

MAINTAINER OBiBa <dev@obiba.org>

COPY data /opt/mica/data
COPY bin /opt/mica/bin

RUN chmod +x -R /opt/mica/bin

RUN \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen wget unzip mysql-client

# Install Mica Drupal client
RUN \
  pear channel-discover pear.drush.org && \
  pear install drush/drush && \
  rm -fr /app && \
  drush make --prepare-install /opt/mica/data/drupal-basic.make /app && \
  cd /tmp && \
  wget -q https://github.com/obiba/mica-drupal7-client/archive/master.zip && \
  unzip master && rm master.zip && \
  cp -r mica-drupal7-client-master/drupal/modules/mica_client /app/sites/all/modules && \
  cp -r mica-drupal7-client-master/drupal/themes/micado_bootstrap /app/sites/all/themes && \
  wget -q https://github.com/obiba/drupal7-auth/archive/master.zip && \
  unzip master && rm master.zip && \
  mv drupal7-auth-master /app/sites/all/modules/obiba_auth && \
  wget -q https://github.com/obiba/drupal7-protobuf/archive/master.zip && \
  unzip master && rm master.zip && \
  mv drupal7-protobuf-master /app/sites/all/modules/obiba_protobuf

# Config and set permissions for setting.php
RUN cp /app/sites/default/default.settings.php /app/sites/default/settings.php && \
    chmod a+w /app/sites/default/settings.php && \
    chmod a+w /app/sites/default

RUN cp /opt/mica/data/htaccess /app/.htaccess

# Define default command.
CMD ["bash", "-c", "/opt/mica/bin/start.sh"]

# http
EXPOSE 80