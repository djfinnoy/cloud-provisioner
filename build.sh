#!/bin/sh

if [ -z $1 ]; then
  CONTAINER=gcp-provisioner
fi

docker-compose build $CONTAINER

