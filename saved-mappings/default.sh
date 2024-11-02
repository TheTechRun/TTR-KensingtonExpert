#!/usr/bin/env bash

# Device name
DEVICE="Kensington Expert Wireless TB Mouse"

# Reset to default settings first
xinput set-prop "$DEVICE" "libinput Scroll Method Enabled" 0, 0, 0
xinput set-prop "$DEVICE" "libinput Button Scrolling Button" 0
xinput set-prop "$DEVICE" "libinput Horizontal Scroll Enabled" 0

# Apply button mapping
xinput set-button-map "$DEVICE" 1 2 3 4 5 6 7 8 9 10

