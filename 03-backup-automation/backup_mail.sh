#!/bin/bash
# Backup Automation - timestamped tar.gz of /var/mail, logs operations,
# keeps only the 5 most recent backups. Author: Nicolas Hoyos | Runs on VM3

SOURCE="/var/mail"                              # directory we are backing up
BACKUP_DIR="/var/backups/mail"                  # where we store the archives
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')              # unique stamp for each backup name
RETENTION=5                                     # how many backups to keep
LOGFILE="/var/backups/mail/backup.log"          # log of every operation

mkdir -p "$BACKUP_DIR"                          # create backup dir if missing
BACKUP_FILE="$BACKUP_DIR/mail_backup_$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_FILE" "$SOURCE"               # c=create z=gzip f=filename
echo "$(date '+%Y-%m-%d %H:%M:%S') | Backup created: $BACKUP_FILE" >> "$LOGFILE"

# Retention: list newest-first, skip 5, delete the rest
ls -t "$BACKUP_DIR"/mail_backup_*.tar.gz | tail -n +$((RETENTION+1)) | xargs -r rm --
echo "$(date '+%Y-%m-%d %H:%M:%S') | Retention applied: kept $RETENTION newest backups" >> "$LOGFILE"
echo "Backup complete. Archive saved to $BACKUP_FILE"
