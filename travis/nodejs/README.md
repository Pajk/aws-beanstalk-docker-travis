# NodeJS projects build tools

## Environment variables

`DOCKER_ACCOUNT` [docker-account]

`DOCKER_IMAGE` [name from package.json if present]

`DOCKERFILE_BUILD` [`docker/Dockerfile.build`] - Image to build Node.js native extensions and transpile TypeScript.

`DOCKERFILE_TEST` [`docker/Dockerfile.test`] - Image to run tests, should use artefacts produced by the "build image".

`DOCKERFILE_PROD` [`docker/Dockerfile.prod`] - Production ready image, should use artefacts produced by the "build image".

`COMPOSE_TEST` [`docker/compose.test.yml`] - Compose file to run tests, should use "test image" and start all test dependencies (eg. db, redis).

`COMPOSE_INTEGRATION` - Compose file to run itegration tests, should start all dependencies, run "production image" and test it from the "test image". There's no default so when it's not set, integration test are skipped.

## Example `.travis.yml`

```
sudo: required
language: node_js
node_js: "8"
services: docker

install: git clone git@github.com:Pajk/aws-beanstalk-docker-travis.git devops-ci

script: ./devops-ci/travis/nodejs/script.sh

cache:
  directories: node_modules
```

## Development

To test this out at your machine, clone this repo to `devops-ci` folder inside directory with your project or create a symlink to it.

```
git clone git@github.com:Pajk/aws-beanstalk-docker-travis.git ../devops-ci
ln -s ../devops-ci devops-ci
```

Then run the main script to build everything and run all tests.

```
./devops-ci/travis/nodejs/script.sh
```

After some changes you might want to run only tests.

```
./devops-ci/travis/nodejs/script.sh test
```
