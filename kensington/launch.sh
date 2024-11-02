#!/usr/bin/env bash

# Set the directory path
script_dir="$HOME/.scripts/kensington/saved-mappings"

# Get the list of .sh files in the directory
script_list=$(find "$script_dir" -maxdepth 1 -type f -name "*.sh" | while read file; do
    # Get just the filename without path and remove .sh extension
    basename "$file" .sh
done)

# Check if any .sh files are found
if [ -z "$script_list" ]; then
    rofi -e "No configurations found in $script_dir"
    exit 1
fi

# Display the list of configurations using Rofi and get the selected one
selected=$(echo "$script_list" | rofi -dmenu -i -p "Select a configuration:")

# Check if a configuration was selected
if [ -n "$selected" ]; then
    # Execute the selected script (add back the path and .sh extension)
    "$script_dir/$selected.sh"
else
    exit 0
fi