## Requirements

By default `beanstalk-key` ec2 key pair is used. You need to [create it first](https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#KeyPairs) and

- [`awscli`](https://aws.amazon.com/cli/)
- [`awsebcli`](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html)
- AWS credentials in `beanstalk` profile (`~/.aws/credentials`)
- [`jq`](https://stedolan.github.io/jq/download/) json cli processr

Then check `aws-elasticbeanstalk-ec2-role` role at [aws console](https://console.aws.amazon.com/iam/home?region=eu-central-1#/roles/aws-elasticbeanstalk-ec2-role) and attach `AWSElasticBeanstalkMulticontainerDocker` managed policy. See [aws docs](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_ecs.html) for more info.