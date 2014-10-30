#
# Docker helper
#

mysql_database=drupal_mica 
mysql_root_password=password

no_cache=false

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
	sudo docker run -ti -p 8888:80 --name mica-drupal --link mysql:mysql --link mica:mica -e MYSQL_DATABASE=$(mysql_database) -e MYSQL_ROOT_PASSWORD=$(mysql_root_password) obiba/mica-drupal:snapshot bash

# Show logs
logs:
	sudo docker logs mica-drupal

# Stop a Mica Docker instance
stop:
	sudo docker stop mica-drupal

# Stop and remove a Mica Docker instance
clean: stop
	sudo docker rm mica-drupal

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
clean-mysql: stop-mysql
	sudo docker rm mysql

#
# Mica stack
#

# Start all the Mica stack
run-all: run-mongodb run-mysql run-opal run-mica run
	sleep 30

run-mongodb:
	sudo docker run -d --name mongodb dockerfile/mongodb

run-opal:
	sudo docker run -d -p 8843:8443 -p 8880:8080 --name opal --link mongodb:mongodb obiba/opal:snapshot

run-mica:
	sudo docker run -d -p 8845:8445 -p 8882:8082 --name mica --link mongodb:mongodb --link opal:opal obiba/mica:snapshot

# Stop and clean all the Mica stack
clean-all: clean clean-mica clean-opal clean-mysql clean-mongodb
	
clean-mica:
	sudo docker stop mica
	sudo docker rm mica

clean-opal:
	sudo docker stop opal
	sudo docker rm opal

clean-mongodb:
	sudo docker stop mongodb
	sudo docker rm mongodb

# Seed the Mica stack
seed:
	./seed/opal-seed.sh
	./seed/mica-seed.sh