![Diagram](https://github.com/bgd11090/test_aws_tf/blob/main/devopstask.drawio.png)

# Terraform task for AWS

This repository contains scripts and configurations to deploy a system on AWS with the following components:

## Components

- **1 VPC**
- **3 backend subnets**
- **3 frontend subnets**
- **3 database subnets**
- **3 route tables**

### Routing Configuration

- Frontend subnets are routed through the Internet Gateway (IGW).
- Backend subnets are routed through a NAT Gateway (NAT).
- Database subnets are routed through a blackhole.

### EC2 Instances

- **3 EC2 instances** deployed across different availability zones, preferably using Ubuntu 22.04 LTS.

### S3 Bucket

- An S3 bucket for storing static content to be used by the EC2 instances running Nginx.
- EC2 instances have access to download files from this S3 bucket.

### Application Load Balancer (ALB)

- An internet-facing **ALB** listening on ports 80/tcp and 443/tcp.
- Port 80/tcp forcefully redirects to HTTPS.

### Target Group

- A target group configured to route traffic to EC2 instances on port 80/tcp.

## Deployment

The environment is designed to be:

- Easy to apply
- Easy to destroy
- Easy to adjust in terms of instance types, VPC subnets, etc.

## Optional Stretch Objective

As an optional stretch objective, an **Ansible playbook** is provided to:

- Install Nginx on the EC2 instances.
- Inject a simple configuration file for Nginx.

## Usage

To run the provided scripts, ensure you have Docker installed and execute the following command to start a LocalStack container:

``` bash
docker run -d --name localstack -e SERVICES=s3,ec2,alb --restart=unless-stopped -p 4566:4566 localstack/localstack
```

Configure your AWS CLI with the LocalStack profile:

``` bash
aws configure --profile localstack

```
