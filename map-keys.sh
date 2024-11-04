#!/usr/bin/env bash

# Clear screen and show title
clear
echo "=== Kensington Expert Mouse Orientation Selector ==="
echo -e "------------------------\n"

# Create mappers directory if it doesn't exist
MAPPERS_DIR="$HOME/.scripts/TTR-KensingtonExpert/mappers"
mkdir -p "$MAPPERS_DIR"

# Prompt for orientation
PS3="Select mouse orientation (1-3): "
options=("Right Side Up" "Upside Down" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "Right Side Up")
            "$MAPPERS_DIR/right-side-up.sh"
            break
            ;;
        "Upside Down")
            "$MAPPERS_DIR/upside-down.sh"
            break
            ;;
        "Exit")
            echo "Exiting..."
            exit 0
            ;;
        *) 
            echo "Invalid option. Please select 1-3."
            ;;
    esac
done