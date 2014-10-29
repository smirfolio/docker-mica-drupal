#
# Docker helper
#

mysql_database=drupal_mica 
mysql_root_password=password


help:
	@echo "make build run-mysql run stop clean"

# List Docker images
images:
	sudo docker images

#
# Mica Drupal
#

# Build Mica Docker image
build:
	sudo docker build -t="obiba/mica-drupal:snapshot" .

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