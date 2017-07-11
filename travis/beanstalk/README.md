# Elastic Beanstalk Deployment

## Environment variables

### Required

`AWS_ACCESS_KEY_ID` - User with access to given ECR and EB.

`AWS_SECRET_ACCESS_KEY`

`EB_APP` - Elastic Beanstalk app name (eg. `eb-hello-world`)

`EB_ENV` - Elastic Beanstalk environemnt name (e.g `eb-hello-world-staging`)

`DOCKER_ACCOUNT` [beanstalk-example]

`DOCKER_IMAGE` [name from package.json if present]

`DOCKER_REPOSITORY` [`xxxxx.dkr.ecr.eu-central-1.amazonaws.com`] - Docker repository where to upload production image.

### Optional

`ECR_REGION` [`eu-central-1`]

`EB_DOCKERRUN_DIR` [`docker`] - Directory with Elastic Beanstalk config (`Dockerrun.aws.json`).

`EB_KEYPAIR_NAME` [`beanstalk-key`] - AWS keypair name

`EB_PLATFORM` [`64bit Amazon Linux 2017.03 v2.7.1 running Multi-container Docker 17.03.1-ce (Generic)`]

`EB_REGION` [`eu-central-1`]

## `.travis.yml` deploy section

```
deploy:
  provider: script
  script: devops-ci/travis/beanstalk/script.sh
  skip_cleanup: true
  on:
    branch: master
```

## Development

To test this out at home, clone this repo to `devops-ci` folder and create a symlink in your project folder.

```
git clone git@github.com:Pajk/aws-beanstalk-docker-travis.git ../devops-ci
ln -s ../devops-ci devops-ci
bash
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
export EB_APP=eb-hello-world
export EB_ENV=eb-hello-world-staging
./devops-ci/travis/beanstalk/script.sh
```

Docker image $DOCKER_ACCOUNT/$DOCKER_IMAGE:$TAG where $TAG is `git show -s --format=%h` has to exists.

## Travis

Enable Travis builds for your repo and in your Settings set needed env variables, most important are:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- EB_APP
- EB_ENV
- DOCKER_ACCOUNT
- DOCKER_REPOSITORY