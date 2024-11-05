# TTR Kensington.

## This is a script that will allow you to change the mappings on the Kensington Expert Wireless and allow vertical and horizontal scrolling with the trackball. You can then use rofi to switch configurations on the fly. Upside down mode works as well.

## Dependencies:
`git`

`rofi (OPTIONAL)`

## Install:
```
mkdir -p ~/.scripts/
cd ~/.scripts
git clone https://github.com/TheTechRun/TTR-KensingtonExpert
chmod -R +x ~/.scripts/TTR-KensingtonExpert/
```

## Instructions:
### 1. Run the `map-keys.sh`and choose RIGHT-SIDE-UP or UPSIDE-MODE.
```
~/.scripts/TTR-KensingtonExpert/map-keys.sh
```
 Now and go through the prompts (pretty self-explanatory) and save your new mappings. Your new configuration will be saved in the `saved-mappings` directory.

### 2. You can either:

a): In terminal, run your new configuration script located in the `saved-mappings` directory.
Example: 
```
bash ~/.scripts/TTR-KensingtonExpert/saved-mappings/righty.sh
```

b). Launch via rofi script. This will list all of our configurations in the `saved-mappings` directory so that you can switch them on the fly.
Example:
```
bash ~/.scripts/TTR-KensingtonExpert/launch.sh
```
You can bind the `launch.sh` to a shortcut key. 

Example for i3wm:
```
bindsym Mod1+7 exec $HOME/.scripts/TTR-KensingtonExpert/launch.sh

```

### 3. (Optional): Your button mappings will reset to default after:
- The computer restarts.
- The mouse is disconnected and reconnected.
- The system suspends/resumes a reboot or logout.

#### So here are some more permanent solutions:

#### a). Bind it to a shortcut key.

Example for i3wm:
```
bindsym Mod1+8 exec ~/.scripts/TTR-KensingtonExpert/saved-mappings/lefty.sh
```

#### b). Have it startup with your Window Manager.

Example for i3wm:
```
exec_always --no-startup-id ~/.scripts/TTR-KensingtonExpert/saved-mappings/lefty.sh
```

#### c). Add it to systemD timer.
Example for NixOS in configuration.nix:
```
# Kensington Expert
  systemd.user.services.enable-scroll = {
    description = "Remaps and enable scrolling with Kensington Expert button";
    wantedBy = [ "default.target" ];
    script = "${pkgs.bash}/bin/bash ~/.scripts/TTR-KensingtonExpert/saved-mappings/lefty.sh";
  };
```

## Issues:
If the script does not work then it can be because your mouse name is something different.
Run this command to get your mouse name:
```
xinput list | grep -i kensington
```
Now in `map-keys.sh` replace "Kensington Expert Wireless TB Mouse" with the right output name.
