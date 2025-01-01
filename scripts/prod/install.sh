#!/bin/bash

scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker_files="$scripts/../../docker"

export DOCKER_UID="$(id -u)"
export DOCKER_UNAME="$(whoami)"
export DOCKER_UPASSWORD="$(whoami)"
docker-compose -f "$docker_files/docker-compose.yml" -f "$docker_files/docker-compose.prod.yml" up $1 -d