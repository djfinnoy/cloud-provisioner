#!/bin/sh
if [ -z $1 ]; then
  CONTAINER=gcp-provisioner
fi

CURRENT_UID=$(id -u):$(id -g) docker-compose run $CONTAINER

