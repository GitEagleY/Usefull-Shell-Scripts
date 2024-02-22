#!/bin/bash

set -euo pipefail

# Function to display error and exit
die() {
  echo "Error: $1" >&2
  exit 1
}

# Function to prompt the user for input
prompt_user() {
  read -rp "$1" "$2"
}

# Function to check if a directory exists
check_directory_exists() {
  [ -d "$1" ] || die "Directory does not exist: $1"
}

# Function to create a directory if it doesn't exist
create_directory() {
  mkdir -p "$1" || die "Failed to create directory: $1"
}

# Function to run rsync for backup
run_rsync_backup() {
  rsync_options=(-aHAXS --delete --numeric-ids --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"})
  rsync "${rsync_options[@]}" / "$BACKUP_DIR" || die "rsync failed with error code $?"
}

# Function to create a tarball of the backup
create_tarball() {
  tar -czf "$BACKUP_DIR.tar.gz" -C "$DESTINATION_DIR" "backup_${TIMESTAMP}" || die "Failed to create tarball: $BACKUP_DIR.tar.gz"
  rm -rf "$BACKUP_DIR"
}

# Function to prompt the user for encryption options
prompt_for_encryption() {
  read -rp "Do you want to encrypt the backup? (y/n): " ENCRYPT
  if [ "$ENCRYPT" == "y" ]; then
    read -rp "Enter the encryption key: " ENCRYPTION_KEY
    gpg --output "$BACKUP_DIR.tar.gz.gpg" --encrypt --recipient "$ENCRYPTION_KEY" "$BACKUP_DIR.tar.gz"
    rm -rf "$BACKUP_DIR.tar.gz"
  fi
}

# Main script

# Prompt the user for destination directory
prompt_user "Enter the destination directory: " DESTINATION_DIR
create_directory "$DESTINATION_DIR"

# Create timestamp and backup directory
TIMESTAMP=$(date '+%Y%m%d%H%M%S')
BACKUP_DIR="${DESTINATION_DIR}/backup_${TIMESTAMP}"

# Run rsync for backup
run_rsync_backup

# Create a tarball of the backup
create_tarball

# Prompt the user for encryption options
prompt_for_encryption

echo "Full encrypted backup completed successfully: ${BACKUP_DIR}.tar.gz"
