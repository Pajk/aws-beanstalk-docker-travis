echo
echo == CREATE ECR REPOSITORY
echo

{
    aws ecr describe-repositories --repository-names $ECR_REPO_NAME 2> /dev/null
} || {
    aws ecr create-repository --repository-name $ECR_REPO_NAME
}
