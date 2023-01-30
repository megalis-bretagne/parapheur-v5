# Database backups

## Docker volumes save

### Dump all data:

```bash
set -a && source /opt/iparapheur/current/.env && set +a && sudo -E /opt/iparapheur/dist/backup.sh
```

### Restore dump :

1. Shutdown all containers.
   ```bash
      sudo docker compose down -v
   ```
2. Unzip the archived dump.
   ```bash
      mkdir backup && sudo tar -zxf <path-to-backup>.tar.gz -C backup
   ```

3. Replace .env file
   ```bash
      cp backup/.env_backup_<date of the dump> .env
   ```

4. Replace the ./data folder with the data_<date of the dump> folder in the unzipped dump.
   ```bash
      sudo mv /data/iparapheur /data/iparapheur.bak 
      sudo mv backup/backup_<date of the dump>_data /data/iparapheur
   ```

5. Load the databases dumps

   ```bash
      sudo ./load-backup.sh <path-to-backup-folder> <date_of_the_dump>
   ```

6. Restart all containers
   ```bash
      sudo docker-compose up -d
   ```
