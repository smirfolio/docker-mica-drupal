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

# Run a Mica Docker instance
run:
	docker run -d -p 8888:80 --name mica-drupal --link mysql-obiba:mysql --link mica:mica --link agate:agate -e MYSQL_DATABASE=$(mysql_database) -e MYSQL_ROOT_PASSWORD=$(mysql_root_password) obiba/mica-drupal:snapshot

# Run a Mica Docker instance with shell
run-sh:
	docker run -ti -p 8888:80 --name mica-drupal -v $(pwd):/data --link mysql-obiba:mysql --link mica:mica --link agate:agate -e MYSQL_DATABASE=$(mysql_database) -e MYSQL_ROOT_PASSWORD=$(mysql_root_password) obiba/mica-drupal:snapshot bash

# Show logs
logs:
	docker logs mica-drupal

# Stop a Mica Docker instance
stop:
	docker stop mica-drupal

# Stop and remove a Mica Docker instance
clean: 
	docker rm -f mica-drupal

#
# MySQL
#

# Run a Mysql Docker instance
run-mysql:
	docker run -d --name mysql-obiba -p 3336:3306 -e MYSQL_DATABASE=$(mysql_database) -e MYSQL_ROOT_PASSWORD=$(mysql_root_password) mysql

# Stop a Mysql Docker instance
stop-mysql:
	docker stop mysql-obiba

# Stop and remove a Mysql Docker instance
clean-mysql:
	docker rm -f mysql-obiba

#
# Mica stack
#

# Start all the Mica stack
run-all: run-mongodb run-mysql wait run-agate run-opal run-mica run

wait:
	sleep 5

run-mongodb:
	docker run -d --name mongodb-obiba mongo

run-agate:
	docker run -d -p 8844:8444 -p 8881:8081 --name agate --link mongodb-obiba:mongo obiba/agate:snapshot
	sleep 5

run-opal:
	docker run -d -p 8843:8443 -p 8880:8080 --name opal --link mongodb-obiba:mongo --link agate:agate obiba/opal:snapshot
	sleep 5

run-mica:
	docker run -d -p 8845:8445 -p 8882:8082 --name mica --link mongodb-obiba:mongo --link opal:opal --link agate:agate obiba/mica:snapshot
	sleep 5

# Stop and clean all the Mica stack
clean-all:
	docker rm -f `docker ps -a -q`

stop-all: stop stop-mica stop-opal stop-agate stop-mysql stop-mongodb

stop-agate:
	docker stop agate

clean-agate:
	docker rm -f agate

stop-mica:
	docker stop mica

clean-mica: 
	docker rm -f mica

stop-opal:
	docker stop opal

clean-opal: 
	docker rm -f opal

stop-mongodb:
	docker stop mongodb

clean-mongodb: 
	docker rm -f mongodb

# Pause and unpause all the Mica stack
pause-all:
	docker pause mica-drupal
	docker pause agate
	docker pause mica
	docker pause opal
	docker pause mysql
	docker pause mongodb

unpause-all:
	docker unpause mongodb
	docker unpause mysql
	docker unpause agate
	docker unpause opal
	docker unpause mica
	docker unpause mica-drupal

#
# Seed
#

# Seed the Mica stack
seed-all: seed-opal seed-mica

seed-opal:
	./seed/opal-seed.sh

seed-mica:
	./seed/mica-seed.sh

#
# Images
#

# Pull the latest nightly builds
pull-all:
	docker pull obiba/agate:snapshot
	docker pull obiba/opal:snapshot
	docker pull obiba/mica:snapshot
	docker pull obiba/mica-drupal:snapshot

# Remove all images
clean-images:
	docker rmi -f `docker images -q`
