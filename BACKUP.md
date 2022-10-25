# Database backups

## Docker volumes save

### Dump all data:

```bash
set -a && source .env && set +a && sudo -E ./backup.sh
```

### Restore dump :

   ```bash
      sudo ./load-backup.sh <path-to-backup>
   ```
