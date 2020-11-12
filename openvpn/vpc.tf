resource "aws_vpc" "default" {
  cidr_block = "10.111.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf-vpn-sandbox"
  }
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

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "public_us_east_1a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_us_east_1a.id
}

resource "aws_route_table_association" "public_us_east_1c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_us_east_1c.id
}
