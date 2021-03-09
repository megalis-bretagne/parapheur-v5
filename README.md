i-Parapheur
===========

## Installation

The following command will serve a working i-Parapheur.

```bash
$ docker-compose up
```

To access it on a Linux machine, you may add this resolution in your `/etc/hosts` file :

```
127.0.0.1    iparapheur.dom.local
```

And open the URL : http://iparapheur.dom.local

#### Vault post-install setup

`http://iparapheur.dom.local:8200` for the UI page.  
Most of the initialization can be in the command line, that will return keys to store :

```bash
$ docker-compose up -d vault
  # note that the container name prefix depends
  # on the local project's directory name - here it is "compose"
$ docker exec -it compose_vault_1 vault operator init -key-shares=1 -key-threshold=1
   # Unseal Key 1:       <unseal_key>
   # Initial Root Token: <token>
$ docker exec -it compose_vault_1 vault operator unseal <unseal_key>
$ docker exec -it compose_vault_1 vault login token=<token>
$ docker exec -it compose_vault_1 vault secrets enable -version=2 -path=secret kv
```

- Save the 2 values into the Core's `application.yml` file, at `services.vault.unseal_key` and `token`, or the corresponding environment variables.
- Restart the Core service.

#### Matomo post-install setup

`http://iparapheur.dom.local:9080` for the installation page.  
Click "Next" on the firsts pages. Values are set by Docker's environment variables.

```
Matomo root user : admin
Matomo root pass : *****

Site name        : iparapheur
Site url         : iparapheur.dom.local
```

* Administration (top-left cog)
* Store (in the left menu)
* Install plugin `Custom Dimensions`

This plugin will be set by default in Matomo v.4.x, thus this step will not be necessary anymore.

* Administration (top-left cog)
* Custom Dimensions (in the left menu)
* Action Dimensions : Configure a new dimension...
  * Name : `Bureau`
  * Active : ✓
  * Save

