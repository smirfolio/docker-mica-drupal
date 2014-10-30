Docker Mica Drupal
==================

Mica Drupal client docker. Depends on the dockers:
* mysql
* mongodb
* opal
* mica

To launch the whole Mica stack:

```
make run-all
```

To seed some data in Opal and Mica:

```
make seed-all
```

Then connect to:

* Opal [https://localhost:8843](https://localhost:8843)
* Mica Admin [https://localhost:8845](https://localhost:8845)
* Mica Drupal [http://localhost:8888](http://localhost:8888)

To shutdown the whole Mica stack:

```
make run-all
```

