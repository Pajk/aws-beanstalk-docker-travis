
# Update Dockerrun.aws.json with the current image version

echo
echo == Deploy to EB
echo

IMAGE="$DOCKER_REPOSITORY/$DOCKER_ACCOUNT/$DOCKER_IMAGE"

cd $EB_DOCKERRUN_DIR

if [ ! -f Dockerrun.aws.json ]; then
    echo "File $EB_DOCKERRUN_DIR/Dockerrun.aws.json not found!"
    exit 1
fi

sed -i.bak "s~${IMAGE}\:[^\"]*~${IMAGE}\:${TAG_PRODUCTION}~g" Dockerrun.aws.json

# EB tool deploys files staged in git

git add .

# Configure EB cli

eb init $EB_APP -v \
        --keyname "$EB_KEYPAIR_NAME" \
        --platform "$EB_PLATFORM" \
        --region "$EB_REGION"

# Deploy current version (archive, upload to S3, talk to EB api)
TS=$(date +%Y-%m-%d-%H-%M-%S)

eb deploy $EB_ENV \
    --verbose \
    --region $EB_REGION \
    --staged \
    --label "$TS-$TAG_PRODUCTION" \
    --message "$TRAVIS_COMMIT_MESSAGE"

cd ..
