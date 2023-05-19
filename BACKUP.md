# Database backups

## Docker volumes save

### Dump all data

```bash
cd /opt/iparapheur/current/
set -a && source .env && set +a
sudo -E /opt/iparapheur/dist/backup.sh
```

### Restore dump

_Note: This example assumes the default backup and data folders._

Move the previous data away, if needed
```bash
# Remove the .env file
cd /opt/iparapheur/current
sudo docker compose down -v --remove-orphans
mv .env .env_$(date '+%Y-%m-%d_%H-%M').bak

# Remove the data folder
mv /data/iparapheur /data/iparapheur_$(date '+%Y-%m-%d_%H-%M').bak
```

Restore the new-old data
```bash
# Unzip the archived dump
cd /data/iparapheur_backups
BACKUP_NAME=backup_20XX-XX-XX_XX-XX
mkdir ${BACKUP_NAME}
sudo tar -xzf ${BACKUP_NAME}.tar.gz -C ${BACKUP_NAME}

# Restore the data folder
mv /data/iparapheur /data/iparapheur.$(date '+%Y-%m-%d_%H-%M').bak
mkdir /data/iparapheur
mv /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}_data/iparapheur/* /data/iparapheur/

# Restore the .env file
cd /opt/iparapheur/current
mv /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}.env .env

# Restore databases
set -a && source .env && set +a
sudo docker compose up -d postgres matomo-db
docker compose exec -T matomo-db /usr/bin/mysql -u "${MATOMO_DB_USER}" --password="${MATOMO_DB_PASSWORD}" "${MATOMO_DB_DATABASE}" < /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}_matomo_backup.sql
docker compose exec -T postgres /bin/bash -c "PGPASSWORD=${POSTGRES_PASSWORD} psql --username ${POSTGRES_USER} alfresco"         < /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}_alfresco.sql
docker compose exec -T postgres /bin/bash -c "PGPASSWORD=${POSTGRES_PASSWORD} psql --username ${POSTGRES_USER} flowable"         < /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}_flowable.sql
docker compose exec -T postgres /bin/bash -c "PGPASSWORD=${POSTGRES_PASSWORD} psql --username ${POSTGRES_USER} keycloak"         < /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}_keycloak.sql
docker compose exec -T postgres /bin/bash -c "PGPASSWORD=${POSTGRES_PASSWORD} psql --username ${POSTGRES_USER} ipcore"           < /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}_ipcore.sql
docker compose exec -T postgres /bin/bash -c "PGPASSWORD=${POSTGRES_PASSWORD} psql --username ${POSTGRES_USER} quartz"           < /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}_quartz.sql
docker compose exec -T postgres /bin/bash -c "PGPASSWORD=${POSTGRES_PASSWORD} psql --username ${POSTGRES_USER} pastellconnector" < /data/iparapheur_backups/${BACKUP_NAME}/${BACKUP_NAME}_pastellconnector.sql

# Restart all containers
cd /opt/iparapheur/current
sudo docker compose up -d
```
