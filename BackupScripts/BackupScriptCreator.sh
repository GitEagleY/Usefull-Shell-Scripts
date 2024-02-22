#!/bin/bash

set -e

echo "Backup Configuration Script"

read -p "Enter the source directory: " SOURCE_DIR
read -p "Enter the destination directory: " DESTINATION_DIR

if [ ! -d "$SOURCE_DIR" ] || [ ! -d "$DESTINATION_DIR" ]; then
    echo "Error: Source or destination directory does not exist."
    exit 1
fi

read -p "Do you want to encrypt the backup? (y/n): " ENCRYPT
ENCRYPTION_KEY=""
if [ "$ENCRYPT" == "y" ]; then
    read -p "Enter the encryption key: " ENCRYPTION_KEY
fi

read -p "Choose backup mode: (1) Add to existing backup, (2) Create a new backup: " BACKUP_MODE
case "$BACKUP_MODE" in
    1)
        BACKUP_DIR="$DESTINATION_DIR/latest_backup"
        ;;
    2)
        TIMESTAMP=$(date +%Y%m%d%H%M%S)
        BACKUP_DIR="$DESTINATION_DIR/backup_$TIMESTAMP"
        ;;
    *)
        echo "Error: Invalid backup mode."
        exit 1
        ;;
esac

{
    echo "#!/bin/bash"
    echo ""
    echo "SOURCE_DIR=\"$SOURCE_DIR\""
    echo "DESTINATION_DIR=\"$DESTINATION_DIR\""
    echo "TIMESTAMP=\$(date +%Y%m%d%H%M%S)"
    echo "BACKUP_DIR=\"$BACKUP_DIR\""
    echo ""
    echo "rsync -a --delete \"\$SOURCE_DIR\" \"\$BACKUP_DIR\""
} > backup_script.sh

# Optional: Encrypt the backup script
if [ "$ENCRYPT" == "y" ]; then
    gpg --output backup_script.sh.gpg --encrypt --recipient "$ENCRYPTION_KEY" backup_script.sh
    rm backup_script.sh
fi

chmod +x backup_script.sh*
