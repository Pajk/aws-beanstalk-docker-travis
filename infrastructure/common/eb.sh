echo
echo == CREATE ELASTIC BEANSTALK APP
echo

eb init $EB_APP -v \
        --keyname $EB_KEYPAIR_NAME \
        --platform "$EB_PLATFORM" \
        --region $AWS_REGION \
        --profile $AWS_PROFILE # --debug

aws iam attach-role-policy \
        --role-name aws-elasticbeanstalk-ec2-role \
        --policy-arn arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker

aws iam attach-role-policy \
        --role-name aws-elasticbeanstalk-ec2-role \
        --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

aws iam attach-role-policy \
        --role-name aws-elasticbeanstalk-ec2-role \
        --policy-arn arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess

echo
echo == CREATE ELASTIC BEANSTALK ENVIRONMENT
echo

aws elasticbeanstalk describe-environments --environment-names $EB_ENVIRONMENT | jq .Environments[0]

[[ $EB_LOAD_BALANCER = true ]] && SINGLE="" || SINGLE="--single"

if [ "$1" != "update" ]; then
    eb create $EB_ENVIRONMENT \
            -v \
            --cname $EB_ENVIRONMENT \
            --profile $AWS_PROFILE \
            --region $AWS_REGION \
            --instance_type t2.micro \
            --tier web \
            ${SINGLE} \
            --sample

    eb logs -cw enable
fi

echo
echo EB Environment is available at: $EB_ENVIRONMENT.$AWS_REGION.elasticbeanstalk.com
echo To assign custom domain folow https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/customdomains.html
echo
