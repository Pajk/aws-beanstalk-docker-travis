if [ -z "$DOCKERFILE_PROD" ]; then
    export DOCKERFILE_PROD=docker/Dockerfile.prod
fi

if [ -z "$DOCKERFILE_BUILD" ]; then
    if [ -f docker/Dockerfile.build ]; then
        export DOCKERFILE_BUILD=docker/Dockerfile.build
    fi
fi

if [ -z "$DOCKERFILE_TEST" ]; then
    if [ -f docker/Dockerfile.test ]; then
        export DOCKERFILE_TEST=docker/Dockerfile.test
    fi
fi

if [ -z "$COMPOSE_TEST" ]; then
    if [ -f docker/compose.test.yml ]; then
        export COMPOSE_TEST=docker/compose.test.yml
    fi
fi

if [ -z "$DOCKER_ACCOUNT" ]; then
    export DOCKER_ACCOUNT="docker-account"
fi

if [ -z "$DOCKER_IMAGE" ]; then
    export DOCKER_IMAGE=$(node -p -e "require('./package.json').name")
fi

export TAG_BUILD="build"
export TAG_TEST="test"
export TAG_PRODUCTION=$(git show -s --format=%h)
