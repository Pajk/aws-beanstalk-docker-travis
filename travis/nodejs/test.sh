#!/usr/bin/env bash

set -e

echo
echo == TEST UNIT ==
echo

docker-compose -f $COMPOSE_TEST up --abort-on-container-exit

docker-compose -f $COMPOSE_TEST ps -q | xargs docker inspect -f '{{ .State.ExitCode }}' | while read code; do
    if [ "$code" -eq "1" ]; then
        exit 1
    fi
done