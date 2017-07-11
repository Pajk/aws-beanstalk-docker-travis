#!/usr/bin/env bash

set -e

export IMAGE_BUILD="$DOCKER_ACCOUNT/$DOCKER_IMAGE:$TAG_BUILD"
export IMAGE_TEST="$DOCKER_ACCOUNT/$DOCKER_IMAGE:$TAG_TEST"
export IMAGE_LATEST="$DOCKER_ACCOUNT/$DOCKER_IMAGE:latest"
export IMAGE_PRODUCTION="$DOCKER_ACCOUNT/$DOCKER_IMAGE:$TAG_PRODUCTION"

# Download all npm packages
# This needs to be done outside Docker to avoid hassles
# with ssh keys in order to allow acces to GitHub

echo
echo == NPM INSTALL ==
echo

if [ -f "$DOCKERFILE_BUILD" ]; then
    npm install --ignore-scripts

    echo
    echo == BUILD DEPENDECIES ==
    echo

    docker build -t $IMAGE_BUILD -f $DOCKERFILE_BUILD .
    docker run --rm -v $(pwd):/app -it $IMAGE_BUILD
else
    npm install
fi

if [ -f "$DOCKERFILE_TEST" ]; then
    echo
    echo == BUILD TEST IMAGE ==
    echo

    docker build -t $IMAGE_TEST -f $DOCKERFILE_TEST .
fi

echo
echo == BUILD PRODUCTION IMAGE ==
echo

# Remove development dependencies

if [ -f "$DOCKERFILE_BUILD" ]; then
    docker run --rm -v $(pwd):/app -it $IMAGE_BUILD npm prune --production
else
    npm prune --production
fi

docker build -t $IMAGE_LATEST -f $DOCKERFILE_PROD .
docker tag $IMAGE_LATEST $IMAGE_PRODUCTION
