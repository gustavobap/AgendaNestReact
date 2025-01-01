#!/bin/bash

scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker_files="$scripts/../../docker"

source $docker_files/.env

backend="$docker_files/../backend"
frontend="$docker_files/../frontend"

mkdir -p "$backend/home/$PROJECT"
mkdir -p "$frontend/home/$PROJECT"