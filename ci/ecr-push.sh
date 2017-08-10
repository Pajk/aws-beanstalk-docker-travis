#!/usr/bin/env bash

set -e

###############################################################################
## Scripts arguments
###############################################################################

# Docker image to deploy
IMAGE=${1:-MISSING}

# How should be the image tagged
TAG_ECR=${2:-MISSING}

# Existing tag that should be deployed, default latest
TAG_TO_PUSH=${3:-latest}

###############################################################################
## Expected env variables
###############################################################################

# AWS Docker repository url
ECR_REPO=${ECR_REPO:-MISSING}

# AWS region, default eu-central-1
ECR_REGION=${ECR_REGION:-MISSINT}

###############################################################################
echo
echo == ECR PUSH $IMAGE:$TAG_TO_PUSH AS $IMAGE:$TAG_ECR
echo == REGION $ECR_REGION REPO $ECR_REPO
echo
###############################################################################

###############################################################################
## Login to ECR
###############################################################################

eval $(aws ecr get-login --region $ECR_REGION --no-include-email)

###############################################################################
## Mandatory tagging with ECR repo url
###############################################################################

docker tag $IMAGE:$TAG_TO_PUSH $ECR_REPO/$IMAGE:$TAG_ECR

###############################################################################
## Push to ECR
###############################################################################

docker push $ECR_REPO/$IMAGE:$TAG_ECR
