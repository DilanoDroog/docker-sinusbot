#!/bin/bash

echo "Setting user permissions again"
chown "$USER":"$GROUP" -R "$TS3BOT_DIR/data"

echo "Setting the SameInterval and YoutubeDLPath again"
sed -i "s|SampleInterval = .*|SampleInterval = \"500\"|g" "$TS3BOT_DIR/config.ini"
sed -i "s|YoutubeDLPath = .*|YoutubeDLPath = \"$YTDL_BIN\"|g" "$TS3BOT_DIR/config.ini"

echo "Adding execute access to sinusbot"
chmod 755 "$TS3BOT_DIR/sinusbot"

echo "Starting sinusbot"
sudo -u "$USER" -g "$GROUP" "$TS3BOT_DIR/sinusbot"

