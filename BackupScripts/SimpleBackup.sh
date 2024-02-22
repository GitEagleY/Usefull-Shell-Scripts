#!/bin/bash

# Function to display an error message and exit the script
function display_error() {
    echo "Error: $1"
    exit 1
}

# Function to perform the backup operation
function perform_backup() {
    read -p "Enter source directory: " source_dir
    read -p "Enter destination directory: " dest_dir

    # Check if source directory exists
    if [ ! -d "$source_dir" ]; then
        display_error "Source directory does not exist."
    fi

    # Perform backup using rsync
    rsync -a --delete "$source_dir" "$dest_dir" || display_error "Backup failed."

    echo "Backup completed successfully."
}

# Function to perform the restore operation
function perform_restore() {
    read -p "Enter source directory: " source_dir
    read -p "Enter destination directory: " dest_dir

    # Check if source directory exists
    if [ ! -d "$source_dir" ]; then
        display_error "Source directory does not exist."
    fi

    # Perform restore using rsync
    rsync -a --delete "$source_dir" "$dest_dir" || display_error "Restore failed."

    echo "Restore completed successfully."
}

# Main script starts here

# Prompt user for mode (backup/restore)
read -p "Enter mode (backup/restore): " mode

# Validate mode input
if [ "$mode" != "backup" ] && [ "$mode" != "restore" ]; then
    display_error "Invalid mode. Please enter 'backup' or 'restore'."
fi

# Execute the corresponding function based on the selected mode
if [ "$mode" == "backup" ]; then
    perform_backup
elif [ "$mode" == "restore" ]; then
    perform_restore
fi
