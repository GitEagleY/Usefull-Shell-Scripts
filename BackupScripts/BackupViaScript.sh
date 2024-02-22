#!/bin/bash

set -euo pipefail

# Define variables
SOURCE_DIR="/path/to/source"
DESTINATION_DIR="/path/to/destination"
TIMESTAMP=$(date '+%Y%m%d%H%M%S')
BACKUP_DIR="${DESTINATION_DIR}/backup_${TIMESTAMP}"

# Function to display error and exit
die() {
  echo "Error: $1" >&2
  exit 1
}

# Check if source directory exists
[ -d "$SOURCE_DIR" ] || die "Source directory does not exist: $SOURCE_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR" || die "Failed to create backup directory: $BACKUP_DIR"

# Run rsync for backup
rsync_options=(-a --delete "$SOURCE_DIR" "$BACKUP_DIR")
rsync "${rsync_options[@]}" || die "rsync failed with error code $?"

echo "Backup completed successfully: ${BACKUP_DIR}"
