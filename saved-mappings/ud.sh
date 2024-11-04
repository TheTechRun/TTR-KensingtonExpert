#!/usr/bin/env bash

# Device name
DEVICE="Kensington Expert Wireless TB Mouse"

# Reset to default settings first
xinput set-prop "$DEVICE" "libinput Scroll Method Enabled" 0, 0, 0
xinput set-prop "$DEVICE" "libinput Button Scrolling Button" 0
xinput set-prop "$DEVICE" "libinput Horizontal Scroll Enabled" 0
xinput set-prop "$DEVICE" "libinput Natural Scrolling Enabled" 0
xinput set-prop "$DEVICE" "libinput Rotation Angle" 0

# Reset button map to default
xinput set-button-map "$DEVICE" 1 2 3 4 5 6 7 8 9 10

# Set rotation first
xinput set-prop "$DEVICE" "libinput Rotation Angle" 180

# Apply button mapping for upside down orientation
xinput set-button-map "$DEVICE" 3 1 2 4 5 6 7 8 9 10

# Enable scrolling with proper orientation
xinput set-prop "$DEVICE" "libinput Scroll Method Enabled" 0, 0, 1
xinput set-prop "$DEVICE" "libinput Button Scrolling Button" 2
xinput set-prop "$DEVICE" "libinput Horizontal Scroll Enabled" 1
