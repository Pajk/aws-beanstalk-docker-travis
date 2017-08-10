set -e

###############################################################################
## Script arguments
###############################################################################

# Image to deploy
IMAGE=${1:-MISSING}

# Image tag that was pushed to ECR
TAG_ECR=${2:-MISSING}

# Elastic Beanstalk app
EB_APP=${3:-MISSING}

# Elastic Beanstalk environment
EB_ENV=${4:-MISSING}

# Directory with Dockerrun.aws.json file, default docker
# Image name will be set to $ECR_REPO/$IMAGE:$TAG_ECR
DEPLOY_DIR=${5:-docker}

###############################################################################
## Expected ENV Variables
###############################################################################

# AWS ECR Repository URL
ECR_REPO=${ECR_REPO:-MISSING}

# EB region
EB_REGION=${EB_REGION:-MISSING}

# S3 Bucket to store version bundle
EB_S3_BUCKET=${EB_S3_BUCKET:-MISSING}

###############################################################################
echo
echo == EB DEPLOY $IMAGE:$TAG_ECR
echo == APP $EB_APP, ENV $EB_ENV
echo == REPO $ECR_REPO
echo == EB REGION $EB_REGION
echo == DEPLOY DIR $DEPLOY_DIR
echo
###############################################################################

if [ ! -f $DEPLOY_DIR/Dockerrun.aws.json ]; then
    echo "File $DEPLOY_DIR/Dockerrun.aws.json not found!"
    exit 1
fi

###############################################################################
## Prepare and upload version archive
###############################################################################

# Update Dockerrun.aws.json with the current image ecr tag
sed -i.bak "s~\[IMAGE\]~${ECR_REPO}/${IMAGE}\:${TAG_ECR}~g" $DEPLOY_DIR/Dockerrun.aws.json

EB_VERSION_LABEL="$(date +%Y-%m-%d-%H-%M-%S)--$TAG_ECR"
VERSION_BUNDLE="$EB_VERSION_LABEL.zip"

# Zip content of deploy dir
mkdir -p eb-versions \
    && cd $DEPLOY_DIR \
    && zip -r ../eb-versions/$VERSION_BUNDLE . \
    && cd ..

aws s3 --region $EB_REGION cp \
    eb-versions/$VERSION_BUNDLE \
    s3://$EB_S3_BUCKET/$EB_APP/$VERSION_BUNDLE

###############################################################################
## Create and use new EB application version using the uploaded archive
###############################################################################

aws elasticbeanstalk \
    --region $EB_REGION \
    create-application-version \
    --application-name $EB_APP \
    --version-label $EB_VERSION_LABEL \
    --description "$TRAVIS_COMMIT_MESSAGE" \
    --source-bundle S3Bucket=$EB_S3_BUCKET,S3Key=$EB_APP/$VERSION_BUNDLE \
    --process

aws elasticbeanstalk  \
    --region $EB_REGION \
    update-environment \
    --environment-name $EB_ENV \
    --version-label $EB_VERSION_LABEL

###############################################################################
## WAIT UNTIL UPDATE ENDS AND CHECK ENVIRONMENT STATUS
###############################################################################

STATUS="Status:Updating"
while true; do
    STATUS=`aws elasticbeanstalk --region $EB_REGION describe-environments \
        --environment-names $EB_ENV | grep "\"Status\"" | sed 's/[\", ]//g'`
    echo $STATUS ..

    if [ "$STATUS" != "Status:Updating" ]; then
        break
    fi
    sleep 15
done

EB_STATUS=`aws elasticbeanstalk --region $EB_REGION describe-environments \
        --environment-names $EB_ENV | grep "\"Status\"" | sed 's/[\", ]//g'`

EB_VERSION=`aws elasticbeanstalk --region $EB_REGION describe-environments \
        --environment-names $EB_ENV | grep "\"VersionLabel\"" | sed 's/[\", ]//g'`

EB_HEALTH=`aws elasticbeanstalk --region $EB_REGION describe-environments \
        --environment-names $EB_ENV | grep "\"HealthStatus\"" | sed 's/[\", ]//g'`

echo == STATUS $EB_STATUS
echo == VERSION $EB_VERSION
echo == HEALTH $EB_HEALTH

# When the environement status is not 'Ready' or version label doesn't match the deployed version
# print actual environemnt info and last 10 events
if [ "$EB_STATUS" != "Status:Ready" ] || [ "$EB_VERSION" != "VersionLabel:$EB_VERSION_LABEL" ]; then
    aws elasticbeanstalk \
        --region $EB_REGION \
        describe-environments \
        --environment-names $EB_ENV

    echo
    echo == LAST EB EVENTS
    echo

    aws elasticbeanstalk \
        --region $EB_REGION \
        describe-events \
        --environment-name $EB_ENV \
        --max-items 10 \
        | grep "\"Message\"" \
        | sed 's/[ ]*\"Message\"\: \"\([^\"]*\)\",/ \* \1/g'

    echo
    echo == EB DEPLOY FAILED
    echo
    exit 1
fi

echo
echo == EB DEPLOY DONE
echo
