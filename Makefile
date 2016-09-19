#
# Docker helper
#

mysql_database=drupal_mica 
mysql_root_password=password

no_cache=false

pwd=`pwd`

help:
	@echo "make build run-mysql run stop clean"

#
# Mica Drupal
#

# Build Mica Docker image
build:
	docker build --no-cache=$(no_cache) -t="obiba/mica-drupal:snapshot" .

build14x:
	docker build --no-cache=$(no_cache) -t="obiba/mica-drupal:1.4-snapshot" 1.4-snapshot

run-test:
	rm -rf /tmp/drupal && docker run -ti --volumes /tmp/drupal:/var/www/html --name mica_drupal obiba/mica-drupal:snapshot bash

# Run a Mica stack
run-all:
	COMPOSE_HTTP_TIMEOUT=600 docker-compose up -d

# Stop and clean all the Mica stack
clean-all:
	docker-compose stop -t 60
	docker-compose rm -f -v

# Remove all images
clean-images:
	docker rmi -f `docker images -q`

# Remove all containers
clean-containers:
	docker rm -f `docker ps -a -q`
