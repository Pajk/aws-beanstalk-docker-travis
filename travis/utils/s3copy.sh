#!/usr/bin/env bash

set -e

export CI_PATH=devops-ci

export S3_URI="s3://$1"
export FILEPATH="./$2"

if [ ! -f "$FILEPATH" ]; then
    . $CI_PATH/utils/awscli.sh
    echo "S3 COPY $S3_URI to $FILEPATH"
    aws s3 cp $S3_URI $FILEPATH
else
    echo "S3 COPY SKIPPING - $FILEPATH exists"
fi
