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
  echo "Is Executable: $( [ -x "$file" ] && echo "Yes" || echo "No" )"
  echo "Owner: $(stat -c '%U' "$file")"
}

remove_execute_permission() {
  local file="$1"
  local owner=$(stat -c '%u' "$file")

  if [ -x "$file" ] && [ "$owner" -ne $(id -u) ]; then
    echo "Cannot remove execute permission for files owned by non-root users. Saving details to file."
    echo "File: $file" >> files_to_secure.txt
    echo "Permissions: $(stat -c '%a' "$file")" >> files_to_secure.txt
  elif [ -x "$file" ]; then
    echo "Removing execute permission and granting all permissions to user."
    chmod u=rw,go= "$file"
    echo "Execute permission removed successfully for $file." >> files_to_removed_permissions.txt
  fi
}

read -rp "Enter the directory to scan (press Enter for current directory): " SCAN_DIR
SCAN_DIR=${SCAN_DIR:-"$(pwd)"}
check_directory_exists "$SCAN_DIR"

echo "Checking for executable files with verbose information in $SCAN_DIR"
while IFS= read -r -d '' file; do
  print_file_info "$file"
  remove_execute_permission "$file"
done < <(find "$SCAN_DIR" -type f -executable -print0)
