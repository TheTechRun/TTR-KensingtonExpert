
# Device name
DEVICE="Kensington Expert Wireless TB Mouse"

# First reset everything to defaults
xinput set-prop "Kensington Expert Wireless TB Mouse" "libinput Scroll Method Enabled" 0, 0, 0
xinput set-prop "Kensington Expert Wireless TB Mouse" "libinput Button Scrolling Button" 0
xinput set-prop "Kensington Expert Wireless TB Mouse" "libinput Horizontal Scroll Enabled" 0
xinput set-prop "Kensington Expert Wireless TB Mouse" "libinput Natural Scrolling Enabled" 0
xinput set-prop "Kensington Expert Wireless TB Mouse" "libinput Rotation Angle" 0

# Reset button map to default first
xinput set-button-map "Kensington Expert Wireless TB Mouse" 1 2 3 4 5 6 7 8 9 10

# Apply button mapping
xinput set-button-map "Kensington Expert Wireless TB Mouse" 8 1 2 4 5 6 7 3 9 10

# Enable scrolling
xinput set-prop "Kensington Expert Wireless TB Mouse" "libinput Scroll Method Enabled" 0, 0, 1
xinput set-prop "Kensington Expert Wireless TB Mouse" "libinput Button Scrolling Button" 3
xinput set-prop "Kensington Expert Wireless TB Mouse" "libinput Horizontal Scroll Enabled" 1
