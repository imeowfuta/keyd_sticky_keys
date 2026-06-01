# copy the placeholders to active, replace PLACEHOLDERDIR with $parent_path and PLACEHOLDERKEY with $hotkey
sed -e "s|PLACEHOLDERKEY|$hotkey|g" -e "s|PLACEHOLDERUSER|$current_user|g" base.conf.template > /etc/keyd/base
sed -e "s|PLACEHOLDERKEY|$hotkey|g" -e "s|PLACEHOLDERUSER|$current_user|g" sticky.conf.template > /etc/keyd/sticky

# copy the active base.conf to the default keyd location and reload keyd
cp /etc/keyd/base /etc/keyd/default.conf


if ! (systemctl is-active --quiet keyd); then
    echo "ALERT: keyd is not running, starting keyd and sleeping for 5 seconds"
    sudo systemctl start keyd
    sleep 5
fi

keyd reload

# remove /tmp files as root to make sure they are not locked
rm -f /tmp/stickycurrentkeys &> /dev/null
rm -f /tmp/stickycurrentstate &> /dev/null

#start keyd listening and pipe the output into the tracker script running as non root user
keyd listen | runuser -u "$current_user" -- ./output_tracker.sh
