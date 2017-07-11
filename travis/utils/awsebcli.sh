#!/usr/bin/env bash

set -e

export CLI_PATH="$(type -p "eb")"

if [ -z "$CLI_PATH" ]; then
    pip install --user awsebcli

    export PATH=$PATH:$HOME/.local/bin
fi

echo AWS EB CLI: $(which eb)
