Contributing
============

## Project structure

This project contains a main `docker-compose.yml` file, that should start an i-Parapheur properly.

* `src/main/resources` every needed configuration files
* `src/test` files for the integration tests (Karate)
* `src/gatling` files for the performance tests (Gatling)

## URLs

| URL                                           | Description |
| ---                                           | ---         |
| http://iparapheur.dom.local/                  | IP web UI   |
| http://iparapheur.dom.local:9009/             | Alfresco    |
| http://iparapheur.dom.local:9090/             | Keycloak    |
| http://iparapheur.dom.local/matomo/           | Matomo      |
| http://iparapheur.dom.local/api/swagger-ui/#/ | Swagger UI  |
| http://iparapheur.dom.local:8200/             | Vault       |

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

#### Resetting everything and launching Karate tests

```bash
# ~ 2 min
$ ./dev-reset-and-setup.sh --force
# INFO 8 --- [           main] coop.libriciel.ipcore.IpCoreApplication  : Started IpCoreApplication in 57.176 seconds (JVM running for 59.042)
```

```bash
# 665 tests completed, 254 failed
$ gradle test --info
```

```bash
# 300 tests completed, 75 failed
$ gradle test -Dkarate.options="--tags ~@issue-ip-core-78 --tags ~@ip-web" --info
```

```bash
# 156 tests completed, 13 failed
$ gradle test -Dkarate.options="--tags ~@issue-ip-core-78 --tags ~@ip-web --tags ~@data-validation" --info
```

```bash
# 142 tests completed
$ gradle test -Dkarate.options="--tags ~@fixme-ip-core --tags ~@proposal --tags ~@fixme-karate --tags ~@ip-web" --info
```

## Connecting to local DB

```bash
$ docker exec -it i-parapheur_postgres_1 /bin/sh
$ psql --username "ipcore" --dbname "ipcore"
$ docker exec -it i-parapheur_postgres_1 /usr/bin/psql
```

## Integration tests

### Prerequisites

* Gradle 7.0+ for direct commands. Alternatively, the local gradle-wrapper can be used on CLI.
* For the time being, values below are hard-coded in `src/test/resources/karate-config.js`
    * Make sure the following environment variables are set and correct (see `./.env.dist`)
        * `APPLICATION_PROTOCOL`
        * `APPLICATION_HOST`
    * UI tests will use Chrome / Chromium, so make sure the `CHROME_BIN` environment variable is set: `export CHROME_BIN=/usr/bin/chromium-browser`.
    * Export environment variables from your `.env` once in your terminal before running the tests: `export $(grep -v "^\(#.*\|\s*$\)" .env | xargs)`

### Files

#### Test files

| Path                 | Description                                           |
| ---                  | ---                                                   |
| `src/test/java/`     | Java test classes (you shouldn't need to modify them) |
| `src/test/resources` | Karate tests, environment, helpers, ...               |

#### Test results

| Path                                       | Description                           |
| ---                                        | ---                                   |
| `build/karate-reports/karate-summary.html` | Karate results, with details          |
| `build/reports/tests/test/index.html`      | Gradle results, with way less details |

### Running the tests

For more information, have a look below at "Command-line switches" and "Tags".

### Run all tests

```bash
$ gradle test
```

#### Command-line switches

| Switch                           | Description                                                                                               |
| ---                              | ---                                                                                                       |
| `--info`                         | Verbosity, print some informations while running the tests (use to see `karate.log()` output)             |
| `--debug`                        | Verbosity, print more informations while running the tests (use to see `karate.log()` output)             |
| `-Dkarate.headless=false`        | When running ip-web tests, don't use headless chrome, so you will see the Chrome UI, ideal for developing |
| `-Dkarate.options="--tags @..."` | Use tags to filter out tests, see "Tags" below                                                            |

#### Tags

#### Working with tags

| Tags                                                                                                         | Description                                                                                                               |
| ---                                                                                                          | ---                                                                                                                       |
| `-Dkarate.options="--tags @permissions"`                                                                     | Run tests tagged with `@permissions` only                                                                                 |
| `-Dkarate.options="--tags ~@fixme-ip-core"`                                                                  | Run tests __not__ tagged with `@fixme-ip-core`                                                                            |
| `-Dkarate.options="--tags @permissions,@searching"`                                                          | Run tests tagged with `@permissions` __or__ `@searching`                                                                  |
| `-Dkarate.options="--tags ~@fixme-ip-core --tags ~@todo-ip-core --tags ~@fixme-ip-web --tags ~@todo-ip-web"` | Run currently passing tests (not tagged with either `@fixme-ip-core`, `@fixme-ip-web`, `@todo-ip-core` or `@todo-ip-web`) |

#### Examples

```bash
# Run all currently passing tests
$ gradle test -Dkarate.options="--tags ~@fixme-ip-core --tags ~@todo-ip-core --tags ~@fixme-ip-web --tags ~@todo-ip-web"
# Setup only (currently using ip-core API v. 1)
$ gradle test -Dkarate.options="--tags @setup"
# Run ip-core API v. 1 tests only
$ gradle test -Dkarate.options="--tags @ip-core --tags @api-v1"
# Run ip-web tests
$ gradle test -Dkarate.options="--tags @ip-web"
# Run the test(s) tagged with the @wip tag with a visible Chrome or Chromium web browser and show some informations in the console
$ gradle test --info -Dkarate.options="--tags @wip" -Dkarate.headless=false
# Run all tests, except the ones covered by known issues (98 passed, 68 failed, 166 scenarios, 59 % passing)
$ gradle test -Dkarate.options="--tags ~@issue-ip-core-78" --info
```

#### Available tags

| Tag                | Description                                                                                                          |
| ---                | ---                                                                                                                  |
| `@api-v1`          | Tests for `ip-core` API v. 1 (same as `@ip-core` for the time being)                                                 |
| `@authentication`  | Tests about authentication                                                                                           |
| `@data-validation` | Tests about data validation                                                                                          |
| `@fixme-ip-core`   | Currently failing `ip-core` tests                                                                                    |
| `@fixme-ip-web`    | Currently failing `ip-web` tests                                                                                     |
| `@ip-core`         | Tests for `ip-core` API v. 1 (same as `@api-v1` for the time being)                                                  |
| `@ip-web`          | Tests for `ip-web`                                                                                                   |
| `@l10n`            | Tests about localization                                                                                             |
| `@permissions`     | Tests about permissions                                                                                              |
| `@proposal`        | Proposals to be made to the IP team (used with `@fixme-ip-core`, `@fixme-ip-web`, `@todo-ip-core` or `@todo-ip-web`) |
| `@searching`       | Tests about searching, filtering, sorting                                                                            |
| `@setup`           | Setting up some data for subsequent tests                                                                            |
| `@todo-ip-core`    | An issue is to be filled on the `ip-core` project                                                                    |
| `@todo-ip-web`     | An issue is to be filled on the `ip-web` project                                                                     |
| `@todo-karate`     | Karate tests needed                                                                                                  |
| `@wip`             | Currently unused, use this tag to mark and filter the current test you're working on                                 |

### @todo

- [ ] Covered API routes
    - Get from [Swagger UI](http://iparapheur.dom.local/api/swagger-ui/#/)
        - `$x('//h4//span//text()') + $x('//h4//small//text()')`
        - `$x('//div[contains(@class, "opblock-summary")]')`
    - [@todo: JSON](http://iparapheur.dom.local/api/v2/api-docs)

### References

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

## Re-insert a message from redis error queue

From the shell in the redis conrtainer, assuming we want to reup the latest error message :  
```
redis-cli --raw XREVRANGE ipng-error + - COUNT 1 | tail -n 10 |  tr "\n" " " | xargs redis-cli XADD ipng-proof '*'
```
