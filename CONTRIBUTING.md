Contributing
============

## Project structure

This project contains a main `docker-compose.yml` file, that should start an i-Parapheur properly.  
Every needed configuration files are set in the `src/main/resources` folder.

The `src/test` folder contains everything for the integration/load tests.

## Windows 10 VirtualBox redirect

Testing signature from a Linux/MacOS development desktop may be tricky, since LiberSign is Win10 only.  
The easier way seems to start a Win10 VM in NAT network (the default one) :   
https://developer.microsoft.com/fr-fr/windows/downloads/virtual-machines/

Editing the `C:/Windows/system32/drivers/etc/hosts`, to redirect everything onto the host :

```
10.0.2.2     iparapheur.dom.local
```

## Docker overriding

#### Linux only

You should declare two URLs in your `/etc/hosts` :

```
127.0.0.1     host.docker.internal
127.0.0.1     iparapheur.dom.local
```

#### Launching development mode

Some system-dependant override files are available, to expose every container's ports, and serve appropriate configuration files.  
The system-dependant `override.dev-XXX` docker-compose should be chained right after the production one :

```bash
$ docker-compose -f docker-compose.yml -f docker-compose.override.dev-linux.yml up
```

#### Useful tip :

You might you want to start one of the sub-services natively, on your system.  
Or simply removing a heavy one you won't use (like Matomo and its db)...   
To do so, scale down those services to `0`, to prevent `docker-compose` from starting those :

```bash
$ docker-compose -f docker-compose.yml -f docker-compose.override.dev-linux.yml up \
      --scale core=0 \
      --scale web=0 \
      --scale matomo=0 \
      --scale matomo-db=0
```

## Connecting to local DB

```bash
$ docker exec -it i-parapheur_postgres_1 /bin/sh
$ psql --username "ipcore" --dbname "ipcore"
$ docker exec -it i-parapheur_postgres_1 /usr/bin/psql
```

## Integration tests

### All tests

```bash
$ gradle test
# Tests run: 105, Failures: 71, Errors: 0, Skipped: 0
```

### API (_ip-core_)

| Which tests              | Command                                                                                         | Results 09/04/2021 09:00:00                           |
| ---                      | ---                                                                                             | ---                                                   |
| All tests                | `gradle test --tests ApiV1Test`                                                                 | `Tests run: 100, Failures: 71, Errors: 0, Skipped: 0` |
| Setup only (@fixme)      | `gradle test --tests ApiV1Test -Dkarate.options="--tags @setup,@check-setup"`                   | `Tests run: 12, Failures: 0, Errors: 0, Skipped: 0`   |
| Passing tests only       | `gradle test --tests ApiV1Test -Dkarate.options="--tags ~@fixme-ip-core --tags ~@todo-ip-core"` | `Tests run: 29, Failures: 0, Errors: 0, Skipped: 0`   |
| Failing tests only       | `gradle test --tests ApiV1Test -Dkarate.options="--tags @setup,@fixme-ip-core"`                 | `Tests run: 73, Failures: 67, Errors: 0, Skipped: 0`  |
| @todo-ip-core tests only | `gradle test --tests ApiV1Test -Dkarate.options="--tags @setup,@todo-ip-core"`                  | `Tests run: 10, Failures: 4, Errors: 0, Skipped: 0`   |

### UI (_ip-web_)

```bash
# @fixme: change path, see executable: "/usr/bin/chromium-browser"
$ gradle test --tests WebTest
```

### WIP

```bash
$ gradle test -Dkarate.options="--tags @wip"
```

## @todo

- [ ] Covered API routes
    - Get from [Swagger UI](http://iparapheur.dom.local/api/swagger-ui/#/)
        - `$x('//h4//span//text()') + $x('//h4//small//text()')`
        - `$x('//div[contains(@class, "opblock-summary")]')`
    - [@todo: JSON](http://iparapheur.dom.local/api/v2/api-docs)

## References

- [Karate](https://intuit.github.io/karate/)
- [Karate UI](https://intuit.github.io/karate/karate-core/)

## Performance tests

For stress tests, we use Gatling with a dedicated `src/gatling` folder.  
Every test can be started with the command :

```bash
$ gradle clean gatlingRun
```

Every Integration test should use the `src/gatling/application.yml`'s `tests.repeat_count` value.  
This value can be overridden (increased), to turn those integrations into performance tests :

```bash
$ gradle clean gatlingRun -Dtests.repeat_count=1000000
```

Full run :

```bash
$ gradle clean gatlingRun-coop.libriciel.iparapheur.auth.TenantsSimulation -Dtests.repeat_count=2
$ gradle clean gatlingRun-coop.libriciel.iparapheur.auth.UsersSimulation -Dtests.repeat_count=200
$ gradle clean gatlingRun-coop.libriciel.iparapheur.auth.DesksSimulation -Dtests.repeat_count=10
$ gradle clean gatlingRun-coop.libriciel.iparapheur.flowable.WorkflowSimulation -Dtests.repeat_count=10
$ gradle clean gatlingRun-coop.libriciel.iparapheur.database.TypologySimulation -Dtests.repeat_count=10
$ gradle clean gatlingRun-coop.libriciel.iparapheur.flowable.FolderSimulation -Dtests.repeat_count=500
```

### Other resources

The login page is provided directly by the keycloak container (as required in recommended practices).   
Therefore we provide a customized login page theme, which is added to the keycloak container resources.  
The gitlab project allowing to build those themed login page is
here : [https://gitlab.libriciel.fr/outils/chartegraphique/theme-libriciel-keycloak](https://gitlab.libriciel.fr/outils/chartegraphique/theme-libriciel-keycloak)

## Flowable potential exploitation problem

If flowable is restarted very early in its lifecycle, some locks can remain in the database preventing further start of the container.  
In such cases this command in Flowable DB can be useful :

```sql
-- noinspection SqlNoDataSourceInspectionForFile,SqlResolve

UPDATE public.flw_ev_databasechangeloglock
SET locked= FALSE,
    lockgranted=null,
    lockedby=null
WHERE id = 1;
```
