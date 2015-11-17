#
# Mica Drupal client Dockerfile
#
# https://github.com/obiba/docker-mica-drupal
#

# Pull base image
FROM drupal:7.41

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
  DEBIAN_FRONTEND=noninteractive apt-get -y install git pwgen wget unzip mysql-client php5-curl php5-mysql drush make nodejs && \
  npm install -g bower && \
  git config --global url."https://".insteadOf git://

# Install Mica Drupal client
RUN \
  cd /tmp && \
  wget -q https://github.com/obiba/mica2-home/archive/master.zip && \
  unzip -q master.zip && rm master.zip && \
  cd mica2-home-master && \
  make prepare-drupal-modules-snapshot drupal_dir=/var/www/html

# Config and set permissions for setting.php
RUN \
  cd /var/www/html && \
  cp sites/default/default.settings.php sites/default/settings.php && \
  chmod a+w sites/default/settings.php && \
  chmod a+w sites/default

RUN cp /opt/mica/data/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN cp /opt/mica/data/htaccess /var/www/html/.htaccess

CMD ["/opt/mica/bin/start.sh"]

# http
EXPOSE 80
