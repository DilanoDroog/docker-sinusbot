#!/bin/bash

echo -e -n "Remove containers with status 'exit' ? [y/N]"
read INPUT

if [[ $INPUT =~ ^(y|Y)$ ]]; then
docker rm $(docker ps -q -f status=exited)
else
echo -e "\nCancelling input was not 'y'"
fi
