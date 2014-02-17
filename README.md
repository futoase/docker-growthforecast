docker-growthforecast
=====================

Dockerfile of growthforecast.

How to using?
-------------

```
> vagrant up --provision
> open http://192.168.33.100/
```

If you should be development will setting DEV_MODE to environment variable.
```
> export DEV_MODE=1
> vagrant up --provision
> vagrant ssh
> cd /vagrant
> docker build .
```

If you require time zone for tokyo, then set environment variable with tokyo to TIME_ZONE.

```
> vagrant run -p 80:80 -i -t -e TIME_ZONE=tokyo {{container}} /bin/bash
# date
# Mon Feb 17 18:12:04 JST 2014
```

LICENSE
-------

[Apache License v2.0](http://www.apache.org/licenses/LICENSE-2.0)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/futoase/docker-growthforecast/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

