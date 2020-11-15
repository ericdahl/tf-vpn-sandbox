resource "aws_vpc" "default" {
  cidr_block = "10.111.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf-vpn-sandbox"
  }
}

resource "aws_flow_log" "default" {
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = "${aws_s3_bucket.vpc_flow_logs.arn}/flow-logs/"
  vpc_id               = aws_vpc.default.id

  tags = {
    Name = "tf-vpc-sandbox"
  }
}

resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket = "tf-vpn-sandbox-flow-log"

  force_destroy = true


}

resource "aws_s3_bucket_policy" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {"Service": "delivery.logs.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.vpc_flow_logs.arn}/*",
            "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {"Service": "delivery.logs.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.vpc_flow_logs.arn}"
        }
    ]
}
EOF
}



resource "aws_subnet" "public_us_east_1a" {
  vpc_id = aws_vpc.default.id

  cidr_block              = "10.111.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_us_east_1a"
  }
}

resource "aws_subnet" "public_us_east_1c" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.111.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_us_east_1a"
  }
}

resource "aws_subnet" "private_us_east_1a" {
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.111.111.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_us_east_1a"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table_association" "public_us_east_1a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_us_east_1a.id
}

resource "aws_route_table_association" "public_us_east_1c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_us_east_1c.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private_us_east_1a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.private_us_east_1a.id
}
