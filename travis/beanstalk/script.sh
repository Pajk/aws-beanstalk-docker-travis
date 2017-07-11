#!/usr/bin/env bash

set -e

export CI_PATH=devops-ci/travis

. $CI_PATH/beanstalk/defaults.sh

. $CI_PATH/utils/awscli.sh

. $CI_PATH/utils/awsebcli.sh

. $CI_PATH/beanstalk/push_ecr.sh

. $CI_PATH/beanstalk/deploy_eb.sh