#!/usr/bin/env bash

# Device name
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
    
    local OLD_PS3=$PS3
    PS3="Select function (1-5): "
    
    printf "\n%s\n" "$prompt"
    printf "%s\n" "------------------------"
    
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

echo "=== Kensington Expert Mouse Button Mapper (UPSIDE DOWN) ==="
echo "Current button locations (after 180° rotation):"
echo "------------------------"
echo "Top Left    (was Bottom Right): Right Click"
echo "Top Right   (was Bottom Left):  Left Click"
echo "Bottom Left (was Top Right):    Back Click"
echo "Bottom Right (was Top Left):    Middle Click"
echo -e "------------------------\n"

# Initialize variables with default mappings
TOP_LEFT_MAP=$MIDDLE_CLICK
TOP_RIGHT_MAP=$BACK_CLICK
BOTTOM_LEFT_MAP=$LEFT_CLICK
BOTTOM_RIGHT_MAP=$RIGHT_CLICK

while true; do
    echo "Select button to configure (positions after rotation):"
    echo "1. Top Left (was Bottom Right)"
    echo "2. Top Right (was Bottom Left)"
    echo "3. Bottom Left (was Top Right)"
    echo "4. Bottom Right (was Top Left)"
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

# Simple 180° flip for buttons:
# Each button's function moves to the button directly opposite when rotated 180°
if [ "$SCROLL_BUTTON" -ne 0 ]; then
    case $SCROLL_BUTTON in
        1) FLIPPED_SCROLL=8 ;; # Bottom Left → Top Right
        2) FLIPPED_SCROLL=3 ;; # Top Left → Bottom Right
        3) FLIPPED_SCROLL=2 ;; # Bottom Right → Top Left
        8) FLIPPED_SCROLL=1 ;; # Top Right → Bottom Left
    esac
fi

# Take the output mappings and do a pure 180° rotation
# Each function moves to the button directly opposite
FLIPPED_TOP_LEFT=$BOTTOM_RIGHT_MAP     # Top Left gets Bottom Right's function
FLIPPED_TOP_RIGHT=$BOTTOM_LEFT_MAP     # Top Right gets Bottom Left's function
FLIPPED_BOTTOM_LEFT=$TOP_RIGHT_MAP     # Bottom Left gets Top Right's function
FLIPPED_BOTTOM_RIGHT=$TOP_LEFT_MAP     # Bottom Right gets Top Left's function


# Create configuration script
cat > "$CONFIG_SCRIPT" << EOF
#!/usr/bin/env bash

# Device name
DEVICE="Kensington Expert Wireless TB Mouse"

# Reset to default settings first
xinput set-prop "\$DEVICE" "libinput Scroll Method Enabled" 0, 0, 0
xinput set-prop "\$DEVICE" "libinput Button Scrolling Button" 0
xinput set-prop "\$DEVICE" "libinput Horizontal Scroll Enabled" 0
xinput set-prop "\$DEVICE" "libinput Natural Scrolling Enabled" 0
xinput set-prop "\$DEVICE" "libinput Rotation Angle" 0

# Reset button map to default
xinput set-button-map "\$DEVICE" 1 2 3 4 5 6 7 8 9 10

# Set rotation first
xinput set-prop "\$DEVICE" "libinput Rotation Angle" 180

# SWAP THE POSITIONS:
# If user sets:                We map it to:
# Top Left = 1                 Bottom Right = 1
# Top Right = 3               Bottom Left = 3
# Bottom Left = 8             Top Right = 8
# Bottom Right = 2            Top Left = 2
xinput set-button-map "\$DEVICE" $TOP_RIGHT_MAP $BOTTOM_RIGHT_MAP $TOP_LEFT_MAP 4 5 6 7 $BOTTOM_LEFT_MAP 9 10

EOF

# Add scroll configuration if enabled
if [ "$SCROLL_BUTTON" -ne 0 ]; then
    # Simple 180° flip for scroll button
    case $SCROLL_BUTTON in
        1) FLIPPED_SCROLL=8 ;; # Bottom Left → Top Right
        2) FLIPPED_SCROLL=3 ;; # Top Left → Bottom Right
        3) FLIPPED_SCROLL=2 ;; # Bottom Right → Top Left
        8) FLIPPED_SCROLL=1 ;; # Top Right → Bottom Left
    esac
    
    cat >> "$CONFIG_SCRIPT" << EOF
# Enable scrolling
xinput set-prop "\$DEVICE" "libinput Scroll Method Enabled" 0, 0, 1
xinput set-prop "\$DEVICE" "libinput Button Scrolling Button" $FLIPPED_SCROLL
xinput set-prop "\$DEVICE" "libinput Horizontal Scroll Enabled" 1
EOF
fi

# Ensure the directories have correct permissions
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
    echo "New configuration (after 180° rotation):"
    
    get_button_name() {
        case $1 in
            1) echo "Left Click" ;;
            2) echo "Middle Click" ;;
            3) echo "Right Click" ;;
            8) echo "Back Click" ;;
            *) echo "Unknown" ;;
        esac
    }
    
￼ Star

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
