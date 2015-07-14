#
# Mica Drupal client Dockerfile
#
# https://github.com/obiba/docker-mica-drupal
#

# Pull base image
FROM centurylink/apache-php:latest

MAINTAINER OBiBa <dev@obiba.org>

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

COPY data /opt/mica/data
COPY bin /opt/mica/bin

RUN chmod +x -R /opt/mica/bin

RUN \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen wget unzip mysql-client php5-curl make

# Install Mica Drupal client
RUN \
  pear channel-discover pear.drush.org && \
  pear install drush/drush && \
  cd /tmp && \
  wget -q https://github.com/obiba/mica2-home/archive/master.zip && \
  unzip -q master.zip && rm master.zip && \
  cd mica2-home-master && \
  make prepare-drupal-snapshot && \
  rm -fr /app && ln -s /tmp/mica2-home-master/target/drupal/ /app

# Config and set permissions for setting.php
RUN cp /app/sites/default/default.settings.php /app/sites/default/settings.php && \
    chmod a+w /app/sites/default/settings.php && \
    chmod a+w /app/sites/default

RUN cp /opt/mica/data/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN cp /opt/mica/data/htaccess /app/.htaccess

# Define default command.
CMD ["bash", "-c", "/opt/mica/bin/start.sh"]

# http
EXPOSE 80
