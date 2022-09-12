iparapheur
===========

## Installation

### Prerequisites

The dev mode on Linux now requires Docker engine 20.10+ to work. It is not standard on Ubuntu 18.04's apt repository, so one should install it from docker's
official repository.

Remove older versions of Docker (if needed)

```bash
sudo apt remove docker docker-engine docker.io containerd runc
```

Import Docker repository GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Add Docker CE repository to Ubuntu:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

Install latest packages

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
```

### System settings

Application settings are defined in a `.env` file located at the root of the project.  
First, copy the example file :

```bash
cp .env.dist .env
```

By default, the application will start on the http://iparapheur.dom.local URL.  
You can edit the `.env` file to change the passwords or URLs among others.

#### Create data directories

```bash
sudo mkdir -m 757 -p ./data/solr/data
sudo mkdir -m 757 -p ./data/solr/contentstore
sudo mkdir -m 757 -p ./data/vault/data
sudo mkdir -m 757 -p ./data/alfresco
sudo mkdir -m 757 -p ./data/postgres
sudo mkdir -m 757 -p ./data/matomo/plugins
sudo mkdir -m 757 -p ./data/matomo/config
```

#### Vault post-install setup

`http://iparapheur.dom.local:8200` for the UI page.  
Most of the initialization can be in the command line, that will return keys to store :

```bash
docker-compose up -d vault
  # note that the container name prefix depends
  # on the local project's directory name - here it is "compose"
docker exec -it compose_vault_1 vault operator init -key-shares=1 -key-threshold=1
   # Unseal Key 1:       <unseal_key>
   # Initial Root Token: <token>
docker exec -it compose_vault_1 vault operator unseal <unseal_key>
docker exec -it compose_vault_1 vault login token=<token>
docker exec -it compose_vault_1 vault secrets enable -version=2 -path=secret kv
```

- Save the 2 values into your `.env` file respectively in the variables `VAULT_UNSEAL_KEY` and `VAULT_TOKEN`

#### Matomo post-install setup

```bash
docker-compose up -d nginx matomo matomo-db
```

ou en environnement de développement :

```bash
docker-compose -f docker-compose.yml -f docker-compose.override.dev-linux.yml up -d nginx matomo matomo-db
```

`https://iparapheur.dom.local/matomo/` for the installation page.  
Click "Next" on the firsts pages. Values should already set by Docker's environment variables.

```
Matomo root user : admin
Matomo root pass : **********
Matomo root mail : admin@dom.local

Site name        : i-Parapheur - Général
Site url         : iparapheur.dom.local
Locale           : France
```

* Administration (top-right cog)
* User (in the left menu)
* Security (in the left menu)
* Authentication token (all the way down): Create a new one, named `ipcore`

- Save the token value into your `.env` file in the variables `MATOMO_TOKEN`

## Prometheus settings

You will need "Prometheus Node Exporter" to get your local machine data.

```bash
sudo apt update
sudo apt install prometheus-node-exporter
```

Or in : https://github.com/prometheus/node_exporter.

## Register the service file

```bash
ln -s /opt/iParapheur/iparapheur.service /etc/systemd/system/iparapheur.service
systemctl enable iparapheur
```

## Start

The following command will serve a working i-Parapheur.

```bash
systemctl start iparapheur
```

To access it on a Linux machine, you may add this resolution in your `/etc/hosts` file :

```
127.0.0.1    iparapheur.dom.local
```

And open the URL : http://iparapheur.dom.local

### Defining a custom truststore

On a custom CA-covered URL, some Keycloak calls will be broken.  
We need to create a specific truststore to allow the connexion:

```bash
keytool -import -file data/nginx/ssl/fullchain.pem -alias iparapheur.dom.local -keystore truststore.jks
```

And link it to some specific elements, through the `docker-compose.override.instance.yml` file :

```yml
services:

  core:
    environment:
      - JAVA_OPTS=-Djavax.net.ssl.trustStoreType=PKCS12 -Djavax.net.ssl.trustStore=truststore.p12 -Djavax.net.ssl.trustStorePassword=trusttrust
    volumes:
      - ./truststore.p12:/truststore.p12

  legacy-bridge:
    environment:
      - JAVA_OPTS=-Djavax.net.ssl.trustStoreType=PKCS12 -Djavax.net.ssl.trustStore=truststore.p12 -Djavax.net.ssl.trustStorePassword=trusttrust
    volumes:
      - ./truststore.p12:/truststore.p12
```


## Ipng

What follows assumes that one already has an activated entity on the IPNG network, and is in possession of the corresponding material (certificate / wallet, connection profile, CA cert, ipng host url and Msp id). If not please contact your IPNG provider.  


First fill in the two required var in .env : IPNG_HOST and IPNG_MSP, that must have been provided.  
Create and the copy all the material into the directory data/ipng. It's final structure should look like this :

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

Additionally, if the Entity that will be connected to IPNG already exists, you can map it in `src/main/resources/core/application-ipng.yml`, uncommenting and remplacing the values :  

```yaml
ipng:
  tenantToEntities:
    <iParapheur-entity-uuid>: <Ipng-entity-id>
```


Turn down  and erase containers  : `docker-compose [- f ...] down -v`.
Then start it with the IPNG activated :  `docker-compose [- f ...] -f docker-compose.ipng.yml up -d`
