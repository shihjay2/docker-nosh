#!/bin/sh

# Link configuration file
mkdir -p /var/syncthing/config
ln -s /etc/syncthing/config.xml /var/syncthing/config/config.xml

# Launch Syncthing
/bin/syncthing -home /var/syncthing/config -gui-address 0.0.0.0:8384
