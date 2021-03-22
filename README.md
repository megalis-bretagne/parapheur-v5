i-Parapheur
===========

## Installation

### Prerequisites

The dev mode on Linux now requires Docker engine 20.10+ to work.
It is not standard on Ubuntu 18.04's apt repository, so one should install it from docker's official repository.

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

`http://iparapheur.dom.local/matomo/` for the installation page.  
Click "Next" on the firsts pages. Values should already set by Docker's environment variables.

```
Matomo root user : admin
Matomo root pass : **********
Matomo root mail : admin@dom.local

Site name        : i-Parapheur - Général
Site url         : iparapheur.dom.local
Locale           : France
```

* Administration (top-left cog)
* User (in the left menu)
* Security (in the left menu)
* Authentication token : Create a new one, named `ipcore`

- Save the token value into the Core's `application.yml` file, at `services.stats.token`, or the corresponding environment variables.
- Restart the Core service.
