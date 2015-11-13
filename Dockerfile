#
# Mica Drupal client Dockerfile
#
# https://github.com/obiba/docker-mica-drupal
#

# Pull base image
FROM php:5-apache

MAINTAINER OBiBa <dev@obiba.org>

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

COPY data /opt/mica/data
COPY bin /opt/mica/bin

RUN chmod +x -R /opt/mica/bin

RUN \
  curl -sL https://deb.nodesource.com/setup | bash - && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor git pwgen wget unzip mysql-client php5-curl make nodejs && \
  npm install -g bower && \
  git config --global url."https://".insteadOf git://

# Install Composer
RUN \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Drush
RUN \
  composer global require drush/drush && \
  ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush && \
  drush status

# Install Mica Drupal client
RUN \
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
