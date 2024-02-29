![Diagram](https://github.com/bgd11090/test_aws_tf/blob/main/devopstask.drawio)

docker run -d --name localstack -e SERVICES=s3,ec2,alb --restart=unless-stopped -p 4566:4566 localstack/localstack

aws configure --profile localstack

aws ec2 describe-vpcs --endpoint-url=http://localhost:4566 --profile localstack
