#!/bin/bash

set -e

if [ -z "$AWS_REGION" ]; then
        export AWS_REGION=eu-central-1
fi

if [ -z "$AWS_PROFILE" ]; then
        export AWS_PROFILE=beanstalk
fi

echo
echo AWS PROFILE: $AWS_PROFILE
echo AWS REGION: $AWS_REGION
echo


###  ECR

export ECR_REPO_NAME=beanstalk-example/hello-world

. ../common/ecr.sh

### ELASTICACHE redis (if needed)

# export ELASTICACHE_NAME=helloworldstaging
# export ELASTICACHE_NUM_NODES=1
# export ELASTICACHE_NODE_TYPE=cache.t2.micro

# . ../common/elasticache.sh

### RDS postgres (if needed)

# export RDS_NAME=hello-world-staging
# export RDS_DB_NAME=hello_world
# export RDS_MASTER_USER=root
# export RDS_MASTER_PASSWORD=HelloWorld_*!

# . ../common/rds.sh

### ELASTIC BEANSTALK

export EB_APP=eb-hello-world
export EB_ENVIRONMENT=eb-hello-world-staging
export EB_SCALE_MIN=1
export EB_KEYPAIR_NAME=beanstalk-key # has to be created in advance
export EB_PLATFORM="64bit Amazon Linux 2017.03 v2.7.1 running Multi-container Docker 17.03.1-ce (Generic)"
export EB_LOAD_BALANCER=false

. ../common/eb.sh

eb setenv \
        PORT=8000 \
        --region $AWS_REGION \
        --profile $AWS_PROFILE \
        --environment $EB_ENVIRONMENT

        # redis
        # REDIS_HOST=$ELASTICACHE_ENDPOINT \

        # rds
        # DB_HOST=$RDS_URL \
        # DB_USER=$RDS_MASTER_USER \
        # DB_PASSWORD=$RDS_MASTER_PASSWORD \
        # DB_DATABASE=$RDS_DB_NAME \

eb printenv $EB_ENVIRONMENT \
        --region $AWS_REGION \
        --profile $AWS_PROFILE
