Docker Mica Drupal
==================

Mica Drupal client docker. Depends on the dockers:

* mysql
* mongodb
* agate
* opal
* mica

To launch the whole Mica stack:

```
# Run and link MongoDB, MySQL, Agate, Opal, Mica and Mica Drupal
make run-all
```

Then connect to:

* Agate [https://localhost:8844](https://localhost:8844)
* Opal [https://localhost:8843](https://localhost:8843)
* Mica [https://localhost:8845](https://localhost:8845)
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

