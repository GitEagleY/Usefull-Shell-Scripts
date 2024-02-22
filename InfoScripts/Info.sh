#!/bin/bash

echo "Process ID (\$\$): $$"
echo "Exit Status (\$?): $?"
echo "Script Name (\$0): $0"
echo "All Arguments as a Single Word (\$*): $*"
echo "Number of Arguments (\$#): $#"
echo "Process ID of Last Background Command (\$!): $!"
echo "Job ID of Last Background Command (\$%): $%"

echo -e "\nAdditional Information:"
echo "User Home Directory (\$HOME): $HOME"
echo "Current User (\$USER): $USER"
echo "Current Date and Time: $(date)"
echo "Operating System: $(uname -a)"
echo "File System Information:"
df -h

exit 0
