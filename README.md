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

