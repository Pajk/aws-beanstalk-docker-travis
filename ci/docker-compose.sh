#!/usr/bin/env bash

set -e

echo
echo == RUNING COMPOSE $1
echo

# Run docker compose and exit on error

docker-compose -f $1 up --abort-on-container-exit --remove-orphans

docker-compose -f $1 ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | while read code; do
    if [ "$code" -eq "1" ]; then
        exit 1
    fi
done
