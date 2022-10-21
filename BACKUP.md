# Database backups

## Docker volumes save

### Dump all data:

```bash
sudo ./dump.sh root libriciel2k18 matomo matomo matomo
```

### Restore dump :

1. Shutdown all containers.
   ```bash
      sudo docker compose down -v
   ```
2. Unzip the archived dump.
   ```bash
      sudo tar -xf <PATH_TO_DUMP>
   ```

3. Replace the ./data folder with the data_<date of the dump> folder in the unzipped dump.
   ```bash
      sudo rm -r ./data
      sudo mv -r ./backup_<date of the dump>/backup_<date of the dump>/ ./data
   ```

4. Start the Postgres database
   ```bash
      sudo docker compose up -d postgres matomo-db
   ```

5. Load the databses dumps
   ```bash
      cat matomo-backup.sql | sudo docker exec -i iparapheur-matomo-db-1 /usr/bin/mysql -u <MATOMO_DB_USER> --password=<MATOMO_DB_PASSWORD> <MATOMO_DB_DATABASE>
      sudo docker exec iparapheur-postgres-1 /bin/bash -c "PGPASSWORD=<POSTGRES_PASSWORD> psql --username <POSTGRES_USER> alfresco" <"./data_<date of the dump>/backup_<date of the dump>-alfresco.sql"
      sudo docker exec iparapheur-postgres-1 /bin/bash -c "PGPASSWORD=<POSTGRES_PASSWORD> psql --username <POSTGRES_USER> flowable" <"./data_<date of the dump>/backup_<date of the dump>-flowable.sql"
      sudo docker exec iparapheur-postgres-1 /bin/bash -c "PGPASSWORD=<POSTGRES_PASSWORD> psql --username <POSTGRES_USER> ipcore" <"./data_<date of the dump>/backup_<date of the dump>-ipcore.sql"
      sudo docker exec iparapheur-postgres-1 /bin/bash -c "PGPASSWORD=<POSTGRES_PASSWORD> psql --username <POSTGRES_USER> keycloak" <"./data_<date of the dump>/backup_<date of the dump>-keycloak.sql"
      sudo docker exec iparapheur-postgres-1 /bin/bash -c "PGPASSWORD=<POSTGRES_PASSWORD> psql --username <POSTGRES_USER> pastellconector" <"./data_<date of the dump>/backup_<date of the dump>-pastellconector.sql"
      sudo docker exec iparapheur-postgres-1 /bin/bash -c "PGPASSWORD=<POSTGRES_PASSWORD> psql --username <POSTGRES_USER> quartz" <"./data_<date of the dump>/backup_<date of the dump>_backup-quartz.sql"
   ```

6. Restart all conatiners
   ```bash
      sudo docker-compose up -d
   ```
