#
# Mica Drupal client Dockerfile
#
# https://github.com/obiba/docker-mica-drupal
#

# Pull base image
FROM drupal:7.53

MAINTAINER OBiBa <dev@obiba.org>

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

COPY data /opt/mica/data
COPY bin /opt/mica/bin

RUN chmod +x -R /opt/mica/bin

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client php5-curl php5-mysql make

# Install Composer
RUN \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Drush
RUN \
  composer global require drush/drush && \
  ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush && \
  drush dl composer-8.x-1.x && \
  drush status

# Install Mica Drupal client
RUN \
  cd /tmp && \
  curl -Ls https://github.com/obiba/obiba-home/archive/master.tar.gz | tar -xzf - && \
  cd obiba-home-master && \
  make prepare-drupal-modules-snapshot drupal_dir=/var/www/html

# Config and set permissions for setting.php
RUN \
  cd /var/www/html && \
  cp sites/default/default.settings.php sites/default/settings.php && \
  chmod a+w sites/default/settings.php && \
  chmod a+w sites/default

RUN cp /opt/mica/data/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN cp /opt/mica/data/htaccess /var/www/html/.htaccess

ENV DRUPAL_ADMINISTRATOR_PASSWORD=password
ENV MICA_ANONYMOUS_PASSWORD=password
ENV BASE_URL=

VOLUME /var/www/html

# http
EXPOSE 80

# Define default command.
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]
