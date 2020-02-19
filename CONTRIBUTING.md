Contributing
============

## Project structure

This project contains a main `docker-compose.yml` file, that should start an i-Parapheur properly.  
Every needed configuration files are set in the `src/main/resources` folder.

The `src/test` folder contains everything for the integration/load tests.  


## Docker overriding

Some system-dependant override files is available, to expose every container's ports, and serve appropriate configuration files.  
The system-dependant `develop-XXX` compose should be chained immediatly after the production one :

```bash
$ docker-compose -f docker-compose.yml -f docker-compose.override.develop-macos.yml up
```

Some `disable-XXX` files are available, if you want to start one of the sub-services natively on your system.  
Those can be daisy-chained like so :

```bash
$ docker-compose -f docker-compose.yml -f docker-compose.override.develop-macos.yml \
    -f docker-compose.override.disable-matomo.yml \
    -f docker-compose.override.disable-web.yml \
    -f docker-compose.override.disable-core.yml \
        up
```


## Integration tests

For integration tests, we use Gatling with a dedicated `src/test` folder.  
Every test can be started with the command :
```bash
$ mvn gatling:test
$ mvn gatling:test -Dgatling.simulationClass=coop.libriciel.iparapheur.auth.UsersSimulation
```

## Performance test

Every Integration test should use the `src/gatling/application.yml`'s `tests.repeat_count` value.  
This value can be overridden (increased), to turn those integration into performance tests :
```bash
$ mvn gatling:test -Dtests.repeat_count=1000000
```
