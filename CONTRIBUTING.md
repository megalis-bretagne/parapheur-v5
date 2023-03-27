Contributing
============

## Project structure

#### File structure
This project contains a main `docker-compose.yml` file, that should start an iparapheur properly.

* `src/main/resources` every needed configuration files
* `src/test` files for the integration tests (Karate)
* `src/gatling` files for the performance tests (Gatling)
* `build/karate-reports/karate-summary.html` Karate tests results

#### URLs

| URL                                                    | Description                |
|--------------------------------------------------------|----------------------------|
| http://iparapheur.dom.local/                           | IP web UI                  |
| http://iparapheur.dom.local:9009/                      | Alfresco                   |
| http://iparapheur.dom.local/auth/                      | Keycloak                   |
| http://iparapheur.dom.local/matomo/                    | Matomo                     |
| http://iparapheur.dom.local/api/swagger-ui/index.html  | Swagger UI                 |
| http://iparapheur.dom.local:8200/                      | Vault                      |
| http://iparapheur.dom.local/ws-iparapheur?wsdl         | Legacy Bridge MTOM wsdl    |
| http://iparapheur.dom.local/ws-iparapheur-no-mtom?wsdl | Legacy Bridge no MTOM wsdl |

## Signature setup

#### Windows 10 VirtualBox redirect

Testing signature from a Linux/MacOS development desktop may be tricky, since LiberSign is Win10 only.
The easier way seems to start a Win10 VM in NAT network (the default one) :
https://developer.microsoft.com/fr-fr/windows/downloads/virtual-machines/

Editing the `C:/Windows/system32/drivers/etc/hosts`, to redirect everything onto the host :

```
10.0.2.2     iparapheur.dom.local
```

#### Fortify implementation (MacOS and Linux) (For debug only)


###### APPLICATION_HOST setup

Fortify uses WebCrypto for signature, which only works in a secure environment.

If you want to use fortify to sign in localhost, you can set the **APPLICATION_HOST** envirnoment variable to **iparapheur.dom.localhost**. Keep in mind that *
.localhost cannot be accessed from a virtual machine.

###### Web settings

1. Create a *settings.json* file in *src/main/resources/web* that contains :
    ```json
    {
      "admin": {
        "enableFortify": true
      }
    }
    ```

2. Create a docker compose override file with this content :
    ```yaml
    services:
      web:
        volumes:
          - ./src/main/resources/web/settings.json:/usr/share/nginx/html/assets/settings.json
    ```

3. When starting the app do not forget to add the override :
    ```bash
    sudo docker compose -f docker-compose.yml -f docker-compose.your-override.yml up -d
    ```

## Application setup

#### System settings

Application settings are defined in a `.env` file located at the root of the project.  
First, copy the example file :

```bash
cp .env.dist .env
```

By default, the application will start on the http://iparapheur.dom.local URL.  
You can edit the `.env` file to change the passwords or URLs among others.

#### Linux only

You should declare two URLs in your `/etc/hosts` :

```
127.0.0.1     host.docker.internal 
127.0.0.1     iparapheur.dom.local #APPLICATION_HOST
```

You should use the create-base-dir.sh to init base directories with rights :

```bash
sudo ./create-base-dir.sh
```

#### Launching development mode

Some system-dependant override files are available, to expose every container's ports, and serve appropriate configuration files.  
The system-dependant `override.dev-XXX` docker-compose should be chained right after the production one :

```bash
sudo docker compose -f docker-compose.yml -f docker-compose.override.dev-linux.yml up -d
```

#### Useful tip :

You might you want to start one of the sub-services natively, on your system.  
Or simply removing a heavy one you won't use (like Matomo and its db)...   
To do so, scale down those services to `0`, to prevent `docker-compose` from starting those :

```bash
sudo docker-compose -f docker-compose.yml -f docker-compose.override.dev-linux.yml up \
      --scale core=0 \
      --scale web=0 \
      --scale matomo=0 \
      --scale matomo-db=0
```

## Integration tests

#### Required software

Developed and tested with the below softwares and versions.

| Software        | Version                |
|-----------------|------------------------|
| bash            | 4.4.20                 |
| curl            | 7.58.0                 |
| docker          | 20.10.5, build 55c4c88 |
| docker-compose  | 1.27.4, build 40524192 |
| gradle          | 4.4.1                  |
| grep (GNU grep) | 3.1                    |
| openjdk         | 11.0.11 2021-04-20     |
| python          | 3.6.9                  |
| sed (GNU sed)   | 4.4                    |
| ubuntu          | 18.04.5 LTS            |

#### Prerequisites

* Gradle 7.0+ for direct commands. Alternatively, the local gradle-wrapper can be used on CLI.
* For the time being, values below are hard-coded in `src/test/resources/karate-config.js`
    * Make sure the following environment variables are set and correct (see `./.env.dist`)
        * `APPLICATION_PROTOCOL`
        * `APPLICATION_HOST`
    * UI tests will use Chrome / Chromium, so make sure the `CHROME_BIN` environment variable is set: `export CHROME_BIN=/usr/bin/chromium-browser`.
    * Export environment variables from your `.env` once in your terminal before running the tests: `export $(grep -v "^\(#.*\|\s*$\)" .env | xargs)`

#### Install Gradle

```bash
sudo apt update
sudo apt upgrade
```

* Install java 17
```bash
sudo apt install openjdk-17-jdk openjdk-17-jre
```

* Check java version
```bash
java -version
```

* Install SDKMAN to download gradle (or download gradle from website https://gradle.org/install/)
```bash
curl -s "https://get.sdkman.io" | bash
```

* Open a new terminal then finally :
```bash
sdk install gradle 8.0.2
```

* Check gradle version
```bash
gradle -v
```

#### Launching Karate tests

- To launch tests based on a tag, use :
```bash
gradle test -Dkarate.options="--tags @tag"
```

- To exclude tests base on a tag, use :
```bash
gradle test -Dkarate.options="--tags ~@ignoredTag"
```

- You can mix both :
```bash
gradle test -Dkarate.options="--tags @tag --tags ~@ignoredTag"
```

- Do not forget to specify the -Dkarate.adminUserPwd option, or the requests won't be authorized

```bash
gradle test -Dkarate.options="--tags @tag --tags ~@ignoredTag" -Dkarate.adminUserPwd="${INITIAL_IPARAPHEUR_ADMIN_PASSWORD}"
```

| Tags                                                                 | Description                                                                                                  | 
|----------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `--tags @setup`                                                      | Setup only (currently using ip-core API v. 1)                                                                |
| `--tags ~@fixme-ip-core --tags ~@proposal --tags ~@fixme-karate`     | Run setup and all passing tests (ip-core and ip-web)                                                         |
| `--tags ~@issue-ip-core-78 --tags ~@ip-web`                          | Run setup and all ip-core tests that won't be fixed by _ip-core - issue #78_                                 |
| `--tags ~@issue-ip-core-78 --tags ~@ip-web --tags ~@data-validation` | Run setup and all ip-core tests that won't be fixed by either _ip-core - issue #78_ or data validation fixes |


#### Run all tests

```bash
gradle test
```

#### Command-line switches

| Switch                           | Description                                                                                               |
|----------------------------------|-----------------------------------------------------------------------------------------------------------|
| `--info`                         | Verbosity, print some informations while running the tests (use to see `karate.log()` output)             |
| `--debug`                        | Verbosity, print more informations while running the tests (use to see `karate.log()` output)             |
| `-Dkarate.adminUserPwd=password` | Specify admin user password                                                                               |
| `-Dkarate.headless=false`        | When running ip-web tests, don't use headless chrome, so you will see the Chrome UI, ideal for developing |
| `-Dkarate.options="--tags @..."` | Use tags to filter out tests, see "Tags" below                                                            |


## IPNG

What follows assumes that one already has an activated entity on the IPNG network, and is in possession of the corresponding material (certificate / wallet,
connection profile, CA cert, IPNG host URL and MSP id). If not please contact your IPNG provider.

First fill in the two required var in `.env` : `IPNG_HOST` and `IPNG_MSP`, that must have been provided.  
Create and the copy all the material into the directory `data/ipng`. It's final structure should look like this :

```
 ./data/ipng/
   - connection-profile.xml
   - ca-certs/
     - ca/
       - <CA cert>.pem
   - wallet/
     - ca/
        <your-IPNG-entity-id>.id
```

Additionally, if the Entity that will be connected to IPNG already exists, you can map it in `src/main/resources/core/application-ipng.yml`, uncommenting and
replacing the values :

```yaml
ipng:
  tenant-to-entities:
    <iparapheur-entity-uuid>: <ipng-entity-id>
```


Turn down and erase containers  : `docker compose [- f ...] down -v`.
Then start it with the IPNG activated :  `docker compose [- f ...] -f docker-compose.ipng.yml up -d`
