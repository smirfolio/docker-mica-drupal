Docker Mica Drupal
==================

Mica Drupal client docker. Depends on the dockers:

* mysql
* mongodb
* [agate](https://hub.docker.com/r/obiba/agate/)
* [opal](https://hub.docker.com/r/obiba/opal/)
* [mica](https://hub.docker.com/r/obiba/mica/)

To launch the whole Mica stack using [docker-compose](https://docs.docker.com/compose/):

```
# Run and link MongoDB, MySQL, Agate, Opal, Mica and Mica Drupal
make run-all
```

Then connect to:

* Agate [http://localhost:8881](http://localhost:8881)
* Opal [http://localhost:8880](http://localhost:8880)
* Mica [http://localhost:8882](http://localhost:8882)
* Mica Drupal [http://localhost:8888](http://localhost:8888)

All username passwords are `administrator/password`.

To shutdown the whole Mica stack:

```
# Stop and remove all docker containers
make clean-all
```

How to force the latest builds from docker repositories:

```
# Remove all docker images of your system
make clean-images
```

