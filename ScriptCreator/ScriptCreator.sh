#!/bin/bash

read -p "Name of script to create-> " SCRIPT_NAME

if [ -z "$SCRIPT_NAME" ]; then
    echo "Error: Script name cannot be empty."
    exit 1
fi

if [ -e "$SCRIPT_NAME" ]; then
    echo "Error: Script '$SCRIPT_NAME' already exists. Choose a different name."
    exit 1
fi

touch "$SCRIPT_NAME"

{
    echo "#!/bin/bash"
    echo "# AUTO CREATED SCRIPT"
} >> "$SCRIPT_NAME"

chmod +x "$SCRIPT_NAME"

echo "Script '$SCRIPT_NAME' created successfully!"
