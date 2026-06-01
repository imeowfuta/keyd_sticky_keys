#!/bin/bash

### CONFIG

# the hotkey combo to activate sticky keys as defined by keyd,
# for a single key no newline is required for example a sole g would just be:  $"g"
# for a combo use the format [MODIFIER]\nKEY for example shift+p would be:  $"[shift]\np"
# note that any combo keys will be stickied initially
hotkey=$"0"

# a blacklist of terms you do not want to see displayed
# "main" should always be included by default
# add more like this:  ("main" "shift" "alt")
blacklist=("main")

### ENDCONFIG

# get the current user
current_user=$(whoami)

# set working directory to script location
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# warn of root escelation and request sudo
echo "The script must temporarily escalate from $current_user to root, see root_commands.sh and the conf templates to see confirmation of what will be run as root"
if [[ $EUID -ne 0 ]]; then
    sudo current_user="$current_user" hotkey="$hotkey" blacklist="$blacklist" bash ./root_commands.sh
fi
