docker-growthforecast
=====================

Dockerfile of growthforecast.

How to running of growthforecast on docker?
-------------------------------------------

This docker image registered on docker index.
If you need running in your machine on the docker daemon, then you must be execute command the  below.

```
> docker run -p 80:80 -d futoase/docker-growthforecast 
```

If you need save datum of growthforecast on docker host, must be add option volume '-v'.

```
> docker run -p 80:80 -v /var/growthforecast/mysql:/var/lib/mysql:rw -d futoase/growthforecast
```

### set time zone to docker container

- set timezone for the tokyo

```
> vagrant run -p 80:80 -i -t -e TIME_ZONE=tokyo futoase/growthforecast /bin/bash
# date
# Mon Feb 17 18:12:04 JST 2014
```

How to development?
--------------------

### build the docker image

```
> vagrant up --provision
> vagrant ssh
> cd /vagrant
> docker build .
```

LICENSE
-------

[Apache License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/futoase/docker-growthforecast/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
