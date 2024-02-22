#!/bin/bash

set -e

echo "Backup Scheduling Script"

read -p "Enter the cron schedule (e.g., '0 2 * * *' for daily at 2 AM): " CRON_SCHEDULE

if ! crontab -l &>/dev/null; then
    echo "Error: Failed to access crontab."
    exit 1
fi

# Set up the cron job
(crontab -l ; echo "$CRON_SCHEDULE /path/to/backup_script.sh") | crontab -

echo "Backup script scheduled successfully using cron."
