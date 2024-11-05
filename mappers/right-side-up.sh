#!/usr/bin/env bash

# Define the device name
DEVICE="Kensington Expert Wireless TB Mouse"

# Define button numbers and their meanings
LEFT_CLICK=1
MIDDLE_CLICK=2
RIGHT_CLICK=3
BACK_CLICK=8
SCROLL="scroll"

# Function to get button function assignment
get_button_function() {
    local prompt=$1
    local choice
    local result
    
    # Save current PS3 prompt
    local OLD_PS3=$PS3
    PS3="Select function (1-5): "
    
    # Print the prompt
    printf "\n%s\n" "$prompt"
    printf "%s\n" "------------------------"
    
    # Handle the selection
    select choice in "Left Click" "Right Click" "Back Click" "Middle Click" "Exit"; do
        case $choice in
            "Left Click")
                PS3=$OLD_PS3
                return $LEFT_CLICK
                ;;
            "Right Click")
                PS3=$OLD_PS3
                return $RIGHT_CLICK
                ;;
            "Back Click")
                PS3=$OLD_PS3
                return $BACK_CLICK
                ;;
            "Middle Click")
                PS3=$OLD_PS3
                return $MIDDLE_CLICK
                ;;
            "Exit")
                PS3=$OLD_PS3
                return 0
                ;;
            *)
                echo "Invalid option. Please select a number between 1 and 5."
                ;;
        esac
    done
}

# Function to select scroll button
get_scroll_button() {
    local choice
    
    printf "\nWhich button would you like to hold to scroll?\n"
    printf "%s\n" "------------------------"
    PS3="Select button for scroll-on-hold (1-5): "
    
    select choice in "Top Left" "Top Right" "Bottom Left" "Bottom Right" "None"; do
        case $choice in
            "Top Left")
                return 2
                ;;
            "Top Right")
                return 8
                ;;
            "Bottom Left")
                return 1
                ;;
            "Bottom Right")
                return 3
                ;;
            "None")
                return 0
                ;;
            *)
                echo "Invalid option. Please select a number between 1 and 5."
                ;;
        esac
    done
}

clear

echo "=== Kensington Expert Mouse Button Mapper ==="
echo "Current button locations:"
echo "------------------------"
echo "Top Left    (Button 2): Middle Click"
echo "Top Right   (Button 8): Back Click"
echo "Bottom Left (Button 1): Left Click"
echo "Bottom Right (Button 3): Right Click"
echo -e "------------------------\n"

# Reset to default settings
xinput set-prop "$DEVICE" "libinput Scroll Method Enabled" 0, 0, 0
xinput set-prop "$DEVICE" "libinput Button Scrolling Button" 0
xinput set-prop "$DEVICE" "libinput Horizontal Scroll Enabled" 0

xinput set-button-map "$DEVICE" 1 2 3 4 5 6 7 8 9 10

# Initialize variables with default mappings
TOP_LEFT_MAP=$MIDDLE_CLICK
TOP_RIGHT_MAP=$BACK_CLICK
BOTTOM_LEFT_MAP=$LEFT_CLICK
BOTTOM_RIGHT_MAP=$RIGHT_CLICK

while true; do
    echo "Select button to configure:"
    echo "1. Top Left"
    echo "2. Top Right"
    echo "3. Bottom Left"
    echo "4. Bottom Right"
    echo "5. Done"
    echo "------------------------"
    read -p "Enter choice (1-5): " button_choice
    
    case $button_choice in
        1)
            get_button_function "Select function for Top Left button:"
            RET=$?
            [ $RET -ne 0 ] && TOP_LEFT_MAP=$RET
            ;;
        2)
            get_button_function "Select function for Top Right button:"
            RET=$?
            [ $RET -ne 0 ] && TOP_RIGHT_MAP=$RET
            ;;
        3)
            get_button_function "Select function for Bottom Left button:"
            RET=$?
            [ $RET -ne 0 ] && BOTTOM_LEFT_MAP=$RET
            ;;
        4)
            get_button_function "Select function for Bottom Right button:"
            RET=$?
            [ $RET -ne 0 ] && BOTTOM_RIGHT_MAP=$RET
            ;;
        5)
            break
            ;;
        *)
            echo "Invalid option. Please select a number between 1-5."
            ;;
    esac
done

# Get scroll button selection
get_scroll_button
SCROLL_BUTTON=$?

# Get script name from user
read -p "Enter a name for this configuration: " config_name
# Convert to lowercase and replace spaces with hyphens
config_name=$(echo "$config_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Create the configuration script in the correct directory
CONFIG_DIR="$HOME/.scripts/TTR-KensingtonExpert/saved-mappings"
mkdir -p "$CONFIG_DIR"
CONFIG_SCRIPT="$CONFIG_DIR/$config_name.sh"

# Check if file already exists
if [ -f "$CONFIG_SCRIPT" ]; then
    read -p "Configuration file already exists. Overwrite? (y/n): " overwrite
    if [ "$overwrite" != "y" ]; then
        echo "Configuration not saved."
        exit 1
    fi
fi

cat > "$CONFIG_SCRIPT" << EOF
# Device name
DEVICE="Kensington Expert Wireless TB Mouse"

# First reset everything to defaults
xinput set-prop "$DEVICE" "libinput Scroll Method Enabled" 0, 0, 0
xinput set-prop "$DEVICE" "libinput Button Scrolling Button" 0
xinput set-prop "$DEVICE" "libinput Horizontal Scroll Enabled" 0
xinput set-prop "$DEVICE" "libinput Natural Scrolling Enabled" 0
xinput set-prop "$DEVICE" "libinput Rotation Angle" 0

# Reset button map to default first
xinput set-button-map "$DEVICE" 1 2 3 4 5 6 7 8 9 10

# Apply button mapping
xinput set-button-map "\$DEVICE" $BOTTOM_LEFT_MAP $TOP_LEFT_MAP $BOTTOM_RIGHT_MAP 4 5 6 7 $TOP_RIGHT_MAP 9 10

EOF

# Add scroll configuration if enabled
if [ "$SCROLL_BUTTON" -ne 0 ]; then
    cat >> "$CONFIG_SCRIPT" << EOF
# Enable scrolling
xinput set-prop "\$DEVICE" "libinput Scroll Method Enabled" 0, 0, 1
xinput set-prop "\$DEVICE" "libinput Button Scrolling Button" $SCROLL_BUTTON
xinput set-prop "\$DEVICE" "libinput Horizontal Scroll Enabled" 1
EOF
fi


Ensure the directories have correct permissions
chmod 755 "$HOME/.scripts/TTR-KensingtonExpert"
chmod 755 "$HOME/.scripts/TTR-KensingtonExpert/saved-mappings"

# Make the script executable and verify
chmod 755 "$CONFIG_SCRIPT"

# Verify the chmod worked
if [ ! -x "$CONFIG_SCRIPT" ]; then
    echo "Warning: Failed to make script executable. Running chmod manually..."
    sudo chmod 755 "$CONFIG_SCRIPT"
fi

# Apply the current configuration
"$CONFIG_SCRIPT"

if [ $? -eq 0 ]; then
    echo -e "\nNew button mapping successfully applied!"
    echo "------------------------"
    echo "New configuration:"
    
    get_button_name() {
        case $1 in
            1) echo "Left Click" ;;
            2) echo "Middle Click" ;;
            3) echo "Right Click" ;;
            8) echo "Back Click" ;;
            *) echo "Unknown" ;;
        esac
    }
    
    get_button_display() {
        local button=$1
        local pos=$2
        if [ "$SCROLL_BUTTON" -eq "$pos" ]; then
            echo "$(get_button_name $button) + Scroll on hold"
        else
            get_button_name $button
        fi
    }
    
    echo "Top Left:     $(get_button_display $TOP_LEFT_MAP 2)"
    echo "Top Right:    $(get_button_display $TOP_RIGHT_MAP 8)"
    echo "Bottom Left:  $(get_button_display $BOTTOM_LEFT_MAP 1)"
    echo "Bottom Right: $(get_button_display $BOTTOM_RIGHT_MAP 3)"
    echo "------------------------"
    echo "Configuration saved to: $CONFIG_SCRIPT"
    echo "Run this script to reapply these settings: $CONFIG_SCRIPT"
else
    echo "Error: Failed to apply button mapping to $DEVICE"
    exit 1
fi
