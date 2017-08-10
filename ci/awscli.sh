#!/usr/bin/env bash

set -e

pip install --upgrade --user awscli

echo AWS CLI: $(which aws)
