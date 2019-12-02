Contributing
============

## Project structure

This project contains a main `docker-compose.yml` file, that should start an i-Parapheur properly.  
Every needed configuration files are set in the `src/main/resources` folder.

The `src/test` folder contains everything for the integration/load tests.  


## Integration tests

For integration tests, we use Gatling with a dedicated `src/test` folder.  
Every test can be started with the command :
```bash
$ mvn gatling:test
$ mvn gatling:test -Dgatling.simulationClass=computerdatabase.BasicSimulation
```

## Performance test

Every Integration test should use the `src/gatling/application.yml`'s `tests.repeat_count` value.  
This value can be overridden (increased), to turn those integration into performance tests :
```bash
$ mvn gatling:test -Dtests.repeat_count=1000000
```
