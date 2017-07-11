
if [ -z "$DOCKER_ACCOUNT" ]; then
    export DOCKER_ACCOUNT="beanstalk-example"
fi

if [ -z "$DOCKER_IMAGE" ]; then
    export DOCKER_IMAGE=$(node -p -e "require('./package.json').name")
fi

if [ -z "$DOCKER_REPOSITORY" ]; then
    export DOCKER_REPOSITORY="xxxxxxx.dkr.ecr.eu-central-1.amazonaws.com"
fi

if [ -z "$ECR_REGION" ]; then
    export ECR_REGION="eu-central-1"
fi

if [ -z "$EB_DOCKERRUN_DIR" ]; then
    export EB_DOCKERRUN_DIR="docker"
fi

if [ -z "$EB_PLATFORM" ]; then
    export EB_PLATFORM="64bit Amazon Linux 2017.03 v2.7.1 running Multi-container Docker 17.03.1-ce (Generic)"
fi

if [ -z "$EB_KEYPAIR_NAME" ]; then
    export EB_KEYPAIR_NAME="beanstalk-key"
fi

if [ -z "$EB_REGION" ]; then
    export EB_REGION="eu-central-1"
fi

export TAG_PRODUCTION=$(git show -s --format=%h)
