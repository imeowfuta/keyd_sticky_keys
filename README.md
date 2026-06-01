A sticky keys tool that is (in theory) desktop environment agnostic and works on both wayland and x11
I made it as I was very annoyed at the lack of proper support by many distro and environments for this essential accessibility feature

### HOW TO RUN IT

Install keyd

Download and unzip the program wherever you want it

Edit the `keyd_sticky_keys.sh` file in a text editor and adjust the two variables to your liking
- hotkey: a string that defines what key/keycombo will toggle sticky keys, see [the manual](https://man.archlinux.org/man/extra/keyd/keyd) for syntax
- blacklist: what keys you want to **exclude** from the status output, usually "shift" "control" "alt" or "meta"

Run `keyd_sticky_keys.sh` **as your regular non-root user**, the program will prompt you when it needs to escalate to root

### WHY DOES THE PROGRAM NEED ROOT?

The program needs root to: write the initial config files to /etc/keyd/, reload keyd and run keyd's listen function. To see what commands will be running as root look in root_commands.sh and the conf templates as these also contain commands that keyd runs

### STATUS OUTPUT

After running the script the program will continuously write the currently active mod keys to `/tmp/stickycurrentkeys` and if sticky keys in enabled to `/tmp/stickycurrentstate`

In order to see this status in a widget or taskbar you can use a widget that prints the output of a command:
for example the kde plugin: [command output](https://store.kde.org/p/2136636/)
or the gnome plugin: [executor](https://raujonas.github.io/executor/)

**To get both modifier keys and stickykeys enabled status**
`printf '%b\n' "$(cat /tmp/stickycurrentkeys) $(cat /tmp/stickycurrentstate)"`

**To get just modifier keys**
`printf '%b\n' "$(cat /tmp/stickycurrentkeys)"`

**To get just enabled status:**
`printf '%b\n' "$(cat /tmp/stickycurrentstate)"`

*If you do not need the status output you can optionally quit the program after it's initial keyd setup has succeeded*
To restart the tracker on it's own after closing it you can use: `sudo keyd listen | ./output_tracker.sh`
