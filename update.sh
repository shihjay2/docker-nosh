#!/bin/bash
# update script

set -e

# Iterate AS containers
SUFFIX="$(basename $PWD)" &&
docker-compose pull
docker-compose down
docker volume rm ${SUFFIX}_nosh_public
docker volume rm ${SUFFIX}_nosh_data
docker-compose up -d

# Clean docker images
docker system prune -f
exit 0
