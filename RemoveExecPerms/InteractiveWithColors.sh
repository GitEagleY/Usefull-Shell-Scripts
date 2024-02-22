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
  local dir_name="$(dirname "$file")"

  # Colors
  local color_yellow="\e[1;33m"  # Yellow
  local color_blue="\e[1;34m"    # Blue
  local color_red="\e[1;31m"     # Red
  local color_cyan="\e[1;36m"    # Cyan
  local color_reset="\e[0m"       # Reset color

  echo -e "File: ${color_blue}$file${color_reset}"
  echo -e "Is Executable: ${color_red}$( [ -x "$file" ] && echo "Yes" || echo "No" )${color_reset}"
  echo -e "Owner: ${color_cyan}$(stat -c '%U' "$file")${color_reset}"
}

remove_execute_permission() {
  local file="$1"
  local owner=$(stat -c '%u' "$file")

  if [ -x "$file" ] && [ "$owner" -ne $(id -u) ]; then
    echo -e "Cannot remove execute permission for files owned by non-root users. Saving details to file."
    echo -e "File: ${color_blue}$file${color_reset}" >> files_to_secure.txt
    echo -e "Permissions: $(stat -c '%a' "$file")" >> files_to_secure.txt
  elif [ -x "$file" ]; then
    echo -e "Removing execute permission and granting all permissions to user."
    chmod u=rw,go= "$file"
    echo -e "Execute permission removed successfully."
  fi
}

read -rp "Enter the directory to scan (press Enter for current directory): " SCAN_DIR
SCAN_DIR=${SCAN_DIR:-"$(pwd)"}
check_directory_exists "$SCAN_DIR"

# Color for directory name
color_yellow="\e[1;33m"  # Yellow
echo -e "Checking for executable files with verbose information in ${color_yellow}$SCAN_DIR${color_reset}"

find "$SCAN_DIR" -type f -executable -print0 | while IFS= read -r -d '' file; do
  print_file_info "$file"
  read -rp "Do you want to remove execute permission? (y/n): " response < /dev/tty
  [ "$response" == "y" ] && remove_execute_permission "$file"
done
