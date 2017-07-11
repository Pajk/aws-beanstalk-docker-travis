#!/usr/bin/env bash

set -e

export CI_PATH=devops-ci/travis

. $CI_PATH/nodejs/defaults.sh

# Run script directly
if [ ! -z "$1" ]; then

    . $CI_PATH/nodejs/$1.sh

# Build images and run tests
else

    . $CI_PATH/nodejs/build.sh

    . $CI_PATH/nodejs/test.sh
fi
