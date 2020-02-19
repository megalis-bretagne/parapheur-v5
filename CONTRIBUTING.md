Contributing
============

## Project structure

This project contains a main `docker-compose.yml` file, that should start an i-Parapheur properly.  
Every needed configuration files are set in the `src/main/resources` folder.

The `src/test` folder contains everything for the integration/load tests.  


## Docker overriding

Some system-dependant override files are available, to expose every container's ports, and serve appropriate configuration files.  
The system-dependant `dev-XXX` compose should be chained right after the production one :

```bash
$ docker-compose -f docker-compose.yml -f docker-compose.overdrive.dev-macos.yml up
```

Useful tip : You might you want to start one of the sub-services natively, on your system.  
Or simply removing a heavy one that you won't use (like Matomo and its db)...   
Scale down those services to 0, to prevent docker-compose from starting those :

```bash
$ docker-compose -f docker-compose.yml -f docker-compose.overdrive.dev-macos.yml up \
      --scale core=0 \
      --scale web=0 \
      --scale matomo=0 \
      --scale matomo-db=0
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
