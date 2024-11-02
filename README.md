# TTR Kensington.

## This is a script that will allow you to change the mappings on the Kensington Expert Wireless and allow vertical and horizontal scrolling with the trackball. You can then use rofi to switch configurations on the fly.

# Dependencies:
`git`
`rofi (OPTIONAL)`

# Install:
```
cd ~/.scripts
git clone https://github.com/TheTechRun/TTR-KensingtonExpert
```

## Instructions:
1. Run the `map-keys.sh`
```
~/.scripts/kensington/map-keys.sh
```
 Now and go through the prompts (pretty self-explanatory) and save your new mappings. Your new configuration will be saved in the `saved-mappings` directory.

2. You can either:
a): In terminal, run your new configuration script located in the `saved-mappings` directory.
Example: 
```
bash ~/.scripts/kensington/saved-mappings/righty.sh
```

b). Launch via rofi script. This will list all of our configurations in the `saved-mappings` directory so that you can switch them on the fly.
Example:
```
bash ~/.scripts/kensington/launch.sh
```
You can bind the `launch.sh` to a shortcut key. 

Example for i3wm:
```
bindsym Mod1+7 exec $HOME/.scripts/kensington/launch.sh

```

3. Optional: Your button mappings will reset to default after:
- The computer restarts
- The mouse is disconnected and reconnected
- The system suspends/resumes a reboot or logout.

Example for i3wm:
```
bindsym Mod1+8 exec $HOME/.scripts/kensington/saved-mappings/lefty.sh
```
Or have it startup with your Window Manager.

Example for i3wm:
```
exec_always --no-startup-id $HOME/.scripts/kensington/saved-mappings/lefty.sh
```

Or add it to systemD timer.

Example for NixOS in configuration.nix:
```
# Kensington Exper
  systemd.user.services.enable-scroll = {
    description = "Remaps and enable scrolling with Kensington Expert button";
    wantedBy = [ "default.target" ];
    script = "${pkgs.bash}/bin/bash ~/.scripts/kensington/saved-mappings/lefty.sh";
  };
```

## Issues:
If the script does not work then it can be because your mouse name is something different.
Run this command to get your mouse name:
```
xinput list | grep -i kensington
```
Now in `map-keys.sh` replace "Kensington Expert Wireless TB Mouse" with the new output name.
