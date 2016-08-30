#!/bin/bash

echo "Setting user permissions again"
chown "$USER":"$GROUP" -R "$TS3BOT_DIR/data"

echo "Adding execute access to sinusbot"
chmod 755 "$TS3BOT_DIR/sinusbot"

echo "Starting sinusbot"
sudo -u "$USER" -g "$GROUP" "$TS3BOT_DIR/sinusbot"

