#!/bin/bash

die() {
  echo "Error: $1" >&2
  exit 1
}

check_directory_exists() {
  [ -d "$1" ] || die "Directory does not exist: $1"
}

print_file_info() {
  local file="$1"
  echo "File: $file"
  echo "Owner: $(stat -c '%U' "$file")"
}

change_ownership() {
  local file="$1"
  local owner=$(stat -c '%u' "$file")
  local main_user_id=$(id -u)

  if [ "$owner" -ne "$main_user_id" ]; then
    echo "Changing ownership to main user and group."
    chown "$main_user_id:$main_user_id" "$file"
    echo "Ownership changed successfully."
  fi
}

read -rp "Enter the directory to scan (press Enter for current directory): " SCAN_DIR
SCAN_DIR=${SCAN_DIR:-"$(pwd)"}
check_directory_exists "$SCAN_DIR"

echo "Checking for files with different ownership in $SCAN_DIR"
while IFS= read -r -d '' file; do
  print_file_info "$file"
  change_ownership "$file"
done < <(find "$SCAN_DIR" -type f -print0)
