#!/bin/bash

docker run --name tsbot-beta \
-d -v /data/ts3bot:/opt/tsbot/data \
-p 8000:8087 tsbot-beta

echo -e -n "\nPress a key to show the logs\n"
if read -t 4 showlog; then
docker logs `docker ps -aq | head -n 1`
fi