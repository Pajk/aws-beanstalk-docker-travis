#!/usr/bin/env bash

set -e

## Update docker only when running on CI platform such as Travis

if [ "$CI" != "true" ]; then
    return
fi

echo
echo == UPDATE DOCKER
echo

docker --version

sudo apt-get update
sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce

docker --version