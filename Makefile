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
	sudo docker build --no-cache=$(no_cache) -t="obiba/mica-drupal:snapshot" .

# Run a Mica Docker instance
run:
	sudo docker run -d -p 8888:80 --name mica-drupal --link mysql:mysql --link mica:mica -e MYSQL_DATABASE=$(mysql_database) -e MYSQL_ROOT_PASSWORD=$(mysql_root_password) obiba/mica-drupal:snapshot

# Run a Mica Docker instance with shell
run-sh:
	sudo docker run -ti -p 8888:80 --name mica-drupal -v $(pwd):/data --link mysql:mysql --link mica:mica -e MYSQL_DATABASE=$(mysql_database) -e MYSQL_ROOT_PASSWORD=$(mysql_root_password) obiba/mica-drupal:snapshot bash

# Show logs
logs:
	sudo docker logs mica-drupal

# Stop a Mica Docker instance
stop:
	sudo docker stop mica-drupal

# Stop and remove a Mica Docker instance
clean: 
	sudo docker rm -f mica-drupal

#
# MySQL
#

# Run a Mysql Docker instance
run-mysql:
	sudo docker run -d --name mysql -p 3336:3306 -e MYSQL_DATABASE=$(mysql_database) -e MYSQL_ROOT_PASSWORD=$(mysql_root_password) centurylink/mysql

# Stop a Mysql Docker instance
stop-mysql:
	sudo docker stop mysql

# Stop and remove a Mysql Docker instance
clean-mysql:
	sudo docker rm -f mysql

#
# Mica stack
#

# Start all the Mica stack
run-all: run-mongodb run-mysql wait run-opal run-mica run

wait:
	sleep 5

run-mongodb:
	sudo docker run -d --name mongodb dockerfile/mongodb

run-opal:
	sudo docker run -d -p 8843:8443 -p 8880:8080 --name opal --link mongodb:mongodb obiba/opal:snapshot
	sleep 5

run-mica:
	sudo docker run -d -p 8845:8445 -p 8882:8082 --name mica --link mongodb:mongodb --link opal:opal obiba/mica:snapshot
	sleep 5

# Stop and clean all the Mica stack
clean-all:
	sudo docker rm -f `sudo docker ps -a -q`

stop-all: stop stop-mica stop-opal stop-mysql stop-mongodb

stop-mica:
	sudo docker stop mica

clean-mica: 
	sudo docker rm -f mica

stop-opal:
	sudo docker stop opal

clean-opal: 
	sudo docker rm -f opal

stop-mongodb:
	sudo docker stop mongodb

clean-mongodb: 
	sudo docker rm -f mongodb

# Pause and unpause all the Mica stack
pause-all:
	sudo docker pause mica-drupal
	sudo docker pause mica
	sudo docker pause opal
	sudo docker pause mysql
	sudo docker pause mongodb

unpause-all:
	sudo docker unpause mongodb
	sudo docker unpause mysql
	sudo docker unpause opal
	sudo docker unpause mica
	sudo docker unpause mica-drupal

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
	sudo docker pull obiba/opal
	sudo docker pull obiba/mica
	sudo docker pull obiba/mica-drupal

# Remove all images
clean-images:
	sudo docker rmi -f `sudo docker images -q`