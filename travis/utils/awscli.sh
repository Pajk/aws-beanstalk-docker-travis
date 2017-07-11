#!/usr/bin/env bash

set -e

export CLI_PATH="$(type -p "aws")"

if [ -z "$CLI_PATH" ]; then
    pip install --user awscli

    export PATH=$PATH:$HOME/.local/bin
fi

echo AWS CLI: $(which aws)
