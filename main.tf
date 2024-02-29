provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.backend_subnets[1].id

  tags = {
    Name = "NAT"
  }
}

resource "aws_route_table" "frontend_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Frontend Route Table"
  }
}

resource "aws_route_table" "backend_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Backend Route Table"
  }
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    blackhole = true
  }

  tags = {
    Name = "Database Route Table"
  }
}

resource "aws_subnet" "frontend_subnets" {
  count             = length(var.frontend_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.frontend_subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags              = {
    Name = "Frontend Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "backend_subnets" {
  count             = length(var.backend_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.backend_subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags              = {
    Name = "Backend Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "database_subnets" {
  count             = length(var.database_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.database_subnet_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  tags              = {
    Name = "Backend Subnet ${count.index + 1}"
  }
}

/*
resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.frontend_subnets[count.index].id
}
*/

resource "aws_instance" "frontend_instance" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.frontend_subnets[0].id  # Frontend subnet in 1st AZ
}

resource "aws_instance" "backend_instance" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.backend_subnets[1].id   # Backend subnet in 2nd AZ
}

resource "aws_instance" "database_instance" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.database_subnets[2].id  # Database subnet in 3rd AZ
}












