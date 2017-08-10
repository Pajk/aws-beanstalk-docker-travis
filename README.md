# Continuous Delivery of Docker Images to AWS Elastic Beanstalk from Travis

Check out an [example app](https://www.github.com/pajk/aws-beanstalk-docker-travis-example) that is using scripts from this repository.

## Required Environment Variables

``` bash
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
ECR_REGION # eg. eu-central-1
ECR_REPO # eg. xxxxxx.dkr.ecr.eu-central-1.amazonaws.com
EB_REGION # eg. eu-central-1
EB_S3_BUCKET # eg. hello-world-versions
```

You can set these in Travis repository settings.

## Example Usage

You can use `EB_APP`, `EB_ENV` and `IMAGE` environment variables or hardcode it in the deploy script as shown below.

``` bash
#!/usr/bin/env bash

set -e

# Clone repo with helpers
ls devops > /dev/null 2>&1 \
    || git clone --single-branch --depth 1 https://github.com/Pajk/aws-beanstalk-docker-travis.git devops

# Install AWS CLI
. devops/ci/awscli.sh

# Install node modules
npm install

# Use git commit hash as image tag
ECR_TAG=$(git show -s --format=%h)
IMAGE=beanstalk-example/hello-world

# Build test and production image
docker build -t $IMAGE:test -f docker/Dockerfile.test .
docker build -t $IMAGE:latest -f docker/Dockerfile.prod .

# Run tests
. devops/ci/docker-compose.sh docker/compose.test.yml

# Push latest available production image to ECR
. devops/ci/ecr-push.sh $IMAGE $ECR_TAG

# Create and use a new EB application version
. devops/ci/eb-deploy.sh \
    $IMAGE $ECR_TAG \
    ${EB_APP} ${EB_ENV} \
    docker # Folder with version files (Dockerrun.aws.json)
```
